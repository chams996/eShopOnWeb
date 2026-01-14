# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/networking/main.tf
# Description: Defines the core network topology, including Virtual Network, 
#              segmented subnets with delegation, and security rules (NSG).
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 1. Virtual Network ---
# The primary network backbone for the eShopOnWeb environment.
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-eshop"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# --- 2. Subnet Definitions ---

# Web Application Subnet: Configured with regional VNet integration.
resource "azurerm_subnet" "webapp_subnet" {
  name                 = "snet-webapp"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  
  # Enabling secure access to backend services via Microsoft backbone.
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Sql"]

  # Service Delegation: Required for Azure App Service VNet Integration.
  delegation {
    name = "webapp_delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Database Subnet: Dedicated segment for SQL data services.
resource "azurerm_subnet" "db_subnet" {
  name                 = "snet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

# Management Subnet: Dedicated for DevOps Agents and administration.
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "snet-management"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
}

# Private Endpoints Subnet: Reserved for secure private link connections.
resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "snet-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
}

# --- 3. Network Security ---

# Database NSG: Restricts traffic to the database layer.
resource "azurerm_network_security_group" "db_nsg" {
  name                = "nsg-db"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Security Rule: Only allows SQL traffic (Port 1433) originating from the WebApp subnet.
  security_rule {
    name                       = "AllowSQLFromWebApp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.1.0/24" # WebApp Subnet IP Range
    destination_address_prefix = "*"
  }
}

# Associating the NSG to the Database Subnet.
resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
