# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/storage/variables.tf
# Description: Input variables for the Storage module to provision Azure 
#              Storage Accounts and containers.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Resource Group Configuration ---
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the storage resources will be provisioned."
}

variable "location" {
  type        = string
  description = "The Azure region where the storage account will be hosted (e.g., West Europe)."
}
