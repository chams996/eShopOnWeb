# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/networking/variables.tf
# Description: Input variables for the Networking module to define the 
#              Virtual Network (VNet) and subnet architecture.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Global Configuration ---
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the networking resources will be deployed."
}

variable "location" {
  type        = string
  description = "The Azure region for the network infrastructure (e.g., East US, West Europe)."
}

# Note: You might want to add CIDR blocks here later (ex: vnet_address_space) 
# to make the module more flexible.
