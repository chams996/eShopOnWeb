# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        backend.tf
# Description: Configures the remote backend for Terraform state management.
#              Stores the .tfstate file in an Azure Storage Account for 
#              collaboration, security, and state locking.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "steshopstatechams2026"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
