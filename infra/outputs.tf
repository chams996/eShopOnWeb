# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        outputs.tf (Root)
# Description: Global outputs for the eShopOnWeb environment. These values 
#              are typically consumed by CI/CD pipelines (GitHub Actions/ADO).
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Resource Group Metadata ---

output "resource_group_id" {
  description = "The unique Azure Resource ID of the project Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "The name of the Resource Group created for this deployment."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The Azure region where the infrastructure is hosted."
  value       = azurerm_resource_group.rg.location
}

# --- Application Entry Points ---

output "webapp_url" {
  description = "The primary public URL for the eShopOnWeb application."
  # Using the module's output for consistency and reliability
  value       = "https://${module.webapp.webapp_url}"
}

output "acr_login_server" {
  description = "The login server for the Azure Container Registry."
  value       = azurerm_container_registry.acr.login_server
}

output "key_vault_uri" {
  description = "The URI of the Key Vault for secret management."
  value       = azurerm_key_vault.kv.vault_uri
}
