# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/storage/outputs.tf
# Description: Output definitions for the Storage module. Provides the 
#              endpoint necessary for the .NET application to serve assets.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Storage Connectivity ---

# CRITICAL INTEGRATION POINT: 
# This output provides the base URL. The .NET application code is designed 
# to append the specific container paths (e.g., "/images/") automatically.
output "primary_blob_endpoint" {
  description = "The primary base URL for the Azure Blob Storage service."
  value       = data.azurerm_storage_account.st.primary_blob_endpoint
}

# Recommendation: Consider also outputting the Storage Account Name 
# if needed for App Settings configuration.
