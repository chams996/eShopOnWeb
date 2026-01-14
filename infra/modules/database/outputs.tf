# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/database/outputs.tf
# Description: Output definitions to expose SQL Server attributes to other 
#              modules (like WebApp) for connection and integration.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Server Connectivity ---
output "sql_server_fqdn" {
  description = "The Fully Qualified Domain Name of the SQL Server instance (e.g., server.database.windows.net)."
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "sql_server_name" {
  description = "The raw name of the SQL Server. Useful for building custom connection strings."
  value       = azurerm_mssql_server.sql.name
}

# --- Resource Metadata ---
output "sql_server_id" {
  description = "The unique Azure Resource ID of the SQL Server, used for setting up dependencies or Private Endpoints."
  value       = azurerm_mssql_server.sql.id
}
