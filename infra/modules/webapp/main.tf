# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/webapp/main.tf
# Description: Provisions the App Service Plan and the Linux Web App. 
#              Configures Docker container settings, VNet integration, 
#              App Insights monitoring, and SQL connection strings.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 1. App Service Plan ---
# Dedicated compute resources for hosting the Linux Web App (Basic B1 Tier).
resource "azurerm_service_plan" "plan" {
  name                = "asp-eshop-chams"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# --- 2. Linux Web App ---
# Primary application host configured for Docker-based deployment.
resource "azurerm_linux_web_app" "webapp" {
  name                = "app-eshop-chams"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  https_only = true

  # Managed Identity: Used for secure ACR image pulling and Key Vault access.
  identity {
    type         = "UserAssigned"
    identity_ids = [var.webapp_identity_id]
  }

  site_config {
    always_on                                     = true
    minimum_tls_version                           = "1.2"
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = var.webapp_client_id
    vnet_route_all_enabled                        = true

    application_stack {
      docker_image_name   = "eshopweb:v3"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  # Application Configuration Environment Variables
  app_settings = {
    "ASPNETCORE_ENVIRONMENT"                = "Production"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string

    # Storage Integration: Trimming suffix ensures the app handles pathing correctly.
    "CatalogBaseUrl"    = trimsuffix(var.storage_url, "/")
    "baseUrls__apiBase" = trimsuffix(var.storage_url, "/")

    # Networking & ACR Connectivity Fixes
    "WEBSITE_PULL_IMAGE_OVER_VNET"          = "false"
    "WEBSITE_DNS_SERVER"                    = "168.63.129.16"
    "WEBSITES_PORT"                         = "8080"
    "DOCKER_REGISTRY_SERVER_URL"            = "https://${var.acr_login_server}"

    # Diagnostics
    "ASPNETCORE_DETAILEDERRORS"             = "true"
  }

  # Database Connection Strings (Catalog, Identity, and Default)
  connection_string {
    name  = "CatalogConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${var.sql_server_name}.database.windows.net,1433;Initial Catalog=eshop-catalog;User ID=${var.sql_user};Password=${var.sql_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "IdentityConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${var.sql_server_name}.database.windows.net,1433;Initial Catalog=eshop-identity;User ID=${var.sql_user};Password=${var.sql_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${var.sql_server_name}.database.windows.net,1433;Initial Catalog=eshop-catalog;User ID=${var.sql_user};Password=${var.sql_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  # Diagnostic Logging Configuration
  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}

# --- 3. VNet Integration ---
# Enables the WebApp to securely access backend resources (SQL, Storage) within the VNet.
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = var.webapp_subnet_id
}
