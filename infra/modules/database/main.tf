# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/database/main.tf
# Description: Provisioning Azure SQL Server and dual databases (Catalog/Identity)
#              with granular firewall security rules for the DevOps environment.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 1. SQL Server Instance ---
# Central server hosting multiple databases with TLS 1.2 enforcement.
resource "azurerm_mssql_server" "sql" {
  name                         = "sql-eshop-chams"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.db_password

  # Public access must be enabled to allow Firewall Rules to filter traffic.
  public_network_access_enabled = true
  minimum_tls_version           = "1.2"
}

# --- 2. Security: Firewall Rules ---
# Implementing the principle of least privilege by restricting access.

# Rule 1: Allow Internal Azure Services (e.g., App Service) to reach the DB.
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Rule 2: Whitelist DevOps VM IP to allow database migrations and management.
resource "azurerm_mssql_firewall_rule" "allow_dev_vm" {
  name             = "AllowDevVM"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "4.225.201.144" # DevOps Agent Public IP
  end_ip_address   = "4.225.201.144"
}

# --- 3. SQL Databases ---
# Creating separate databases for logical isolation of concerns.

# Catalog Database: Stores product and inventory information.
resource "azurerm_mssql_database" "catalog_db" {
  name      = "eshop-catalog"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S0"
}

# Identity Database: Stores user accounts and security data.
resource "azurerm_mssql_database" "identity_db" {
  name      = "eshop-identity"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S0"
}
