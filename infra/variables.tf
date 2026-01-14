# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        variables.tf (Root)
# Description: Global input variables for the environment. These values are
#              passed down to specific modules (Networking, DB, WebApp, etc.)
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- 1. Global Configuration ---

variable "resource_group_name" {
  type        = string
  description = "The name of the primary resource group for the eShop project."
}

variable "location" {
  type        = string
  description = "The Azure region where all resources will be deployed (e.g., Sweden Central)."
}

# --- 2. Database & Security ---

variable "sql_admin_user" {
  type        = string
  description = "The administrator username for the SQL Server instance."
  default     = "sqladmin"
}

variable "db_password" {
  type        = string
  description = "The password for the SQL administrator. Must meet Azure complexity requirements."
  sensitive   = true
}

# Note: 'db_connection_string' was removed because it is built dynamically 
# within the root main.tf to ensure a single source of truth.
