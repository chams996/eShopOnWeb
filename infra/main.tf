# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure (Production-Ready)
# File:        main.tf (Root)
# Description: Main orchestration file that connects networking, database, 
#              storage, and web application modules into a unified Hub-and-Spoke
#              architecture with Private Endpoints and Managed Identities.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 0. Resource Group ---
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# --- 1. Infrastructure Modules ---

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  db_subnet_id        = module.networking.db_subnet_id
  db_password         = var.db_password
}

# --- 2. Identity & Governance ---

resource "azurerm_user_assigned_identity" "webapp_id" {
  name                = "id-eshop-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# --- 3. Monitoring Stack ---

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "log-eshop-chams"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "appinsights" {
  name                = "ins-eshop-chams"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = "web"
}

# --- 4. Security: Key Vault ---

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "kv-eshop-chams-2026"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [
      module.networking.webapp_subnet_id,
      module.networking.mgmt_subnet_id,
      module.networking.endpoint_subnet_id
    ]
    ip_rules = ["4.225.201.144/32"] # Developer Access
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
  }
}

# --- 5. Application Layer: Web App ---

module "webapp" {
  source              = "./modules/webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  webapp_subnet_id    = module.networking.webapp_subnet_id
  webapp_identity_id  = azurerm_user_assigned_identity.webapp_id.id
  webapp_client_id    = azurerm_user_assigned_identity.webapp_id.client_id
  acr_login_server    = azurerm_container_registry.acr.login_server

  sql_server_name     = module.database.sql_server_name
  sql_user            = var.sql_admin_user
  sql_password        = var.db_password

  app_insights_connection_string = azurerm_application_insights.appinsights.connection_string
  app_insights_key               = azurerm_application_insights.appinsights.instrumentation_key
  storage_url                    = module.storage.primary_blob_endpoint

  depends_on = [azurerm_role_assignment.acr_pull]
}

# --- 6. Container Registry (ACR) ---

resource "azurerm_container_registry" "acr" {
  name                = "acreshopchams2026"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  public_network_access_enabled = true # Enabled for seamless Image Pull

  network_rule_set {
    default_action = "Allow"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.webapp_id.principal_id
}

# --- 7. Private Connectivity (SQL) ---

resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "sql-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = module.networking.vnet_id
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "pe-sql-eshop"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.networking.endpoint_subnet_id

  private_service_connection {
    name                           = "sql-privatelink"
    private_connection_resource_id = module.database.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
  }
}

# --- 8. Firewall Rules ---

resource "azurerm_mssql_firewall_rule" "vm_access" {
  count            = 2
  name             = "AllowVM-Chams-${count.index == 0 ? "Catalog" : "Identity"}"
  server_id        = module.database.sql_server_id
  start_ip_address = "4.225.201.144"
  end_ip_address   = "4.225.201.144"
}
