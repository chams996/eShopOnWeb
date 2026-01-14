# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/storage/main.tf
# Description: Manages Azure Storage resources by referencing existing accounts
#              and provisioning necessary blob containers for application assets.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 1. Data Sources ---
# Referencing the pre-existing storage account located in 'tfstate-rg'.
# This allows the module to use the account without managing its lifecycle.
data "azurerm_storage_account" "st" {
  name                = "steshopstatechams2026"
  resource_group_name = "tfstate-rg"
}

# --- 2. Blob Containers ---
# Creating the 'images' container to host product photos and static assets.
# Access type is set to 'blob' to allow public read access for individual blobs.
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = data.azurerm_storage_account.st.name
  container_access_type = "blob"
}
