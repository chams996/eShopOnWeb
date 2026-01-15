# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/networking/outputs.tf
# Description: Output definitions for the Networking module. These IDs are 
#              essential for resource placement and inter-module connectivity.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Core Network IDs ---
output "vnet_id" {
  description = "The unique identifier of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

# --- Subnet Identifiers ---
# These are used to inject resources (WebApp, DB, etc.) into specific network segments.

output "webapp_subnet_id" {
  description = "The ID of the subnet dedicated to the Web Application Service."
  value       = azurerm_subnet.webapp_subnet.id
}

output "db_subnet_id" {
  description = "The ID of the subnet dedicated to the SQL Database services."
  value       = azurerm_subnet.db_subnet.id
}

output "mgmt_subnet_id" {
  description = "The ID of the management subnet (e.g., for Bastion or DevOps agents)."
  value       = azurerm_subnet.mgmt_subnet.id
}

output "endpoint_subnet_id" {
  description = "The ID of the subnet reserved for Private Endpoints."
  value       = azurerm_subnet.endpoint_subnet.id
}
