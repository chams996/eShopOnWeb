# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/webapp/outputs.tf
# Description: Output definitions for the WebApp module. These values are 
#              typically used for CI/CD pipelines and smoke testing.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Application Access & Identification ---

output "webapp_name" {
  description = "The unique name of the Azure Linux Web App. Useful for CLI operations and deployment slots."
  value       = azurerm_linux_web_app.webapp.name
}

output "webapp_url" {
  description = "The default public URL (hostname) of the deployed eShopOnWeb application."
  value       = azurerm_linux_web_app.webapp.default_hostname
}
