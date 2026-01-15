# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/database/variables.tf
# Description: Input variables for the Database module including VNet 
#              integration and security credentials.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Resource Group Configuration ---
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the database resources will be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the database instance will be deployed."
}

# --- Network Integration ---
variable "db_subnet_id" {
  type        = string
  description = "The ID of the specific subnet dedicated to the database. Essential for VNet integration and isolation."
}

# --- Security & Credentials ---
variable "db_password" {
  type        = string
  description = "The administrator password for the SQL Server. This value is sensitive and will be masked in logs."
  sensitive   = true
}
