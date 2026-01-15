# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        modules/webapp/variables.tf
# Description: Input variables for the WebApp module. Integrates Database, 
#              Storage, Monitoring, and Identity for the .NET application.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

# --- Global & Networking Configuration ---
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the App Service resources."
}

variable "location" {
  type        = string
  description = "The Azure region for the WebApp deployment."
}

variable "webapp_subnet_id" {
  type        = string
  description = "The ID of the subnet for VNet integration, enabling secure backend communication."
}

# --- Identity & Container Registry ---
variable "webapp_identity_id" {
  type        = string
  description = "The Resource ID of the User Assigned Managed Identity."
}

variable "webapp_client_id" {
  type        = string
  description = "The Client ID of the Managed Identity used for ACR and Key Vault access."
}

variable "acr_login_server" {
  type        = string
  description = "The URL of the Azure Container Registry (e.g., myacr.azurecr.io)."
}

# --- Database Connectivity (SQL) ---
variable "sql_server_name" {
  type        = string
  description = "The name of the SQL Server to build the connection strings."
}

variable "sql_user" {
  type        = string
  description = "The administrator username for SQL authentication."
}

variable "sql_password" {
  type        = string
  description = "The administrator password for SQL authentication."
  sensitive   = true
}

# --- Monitoring & Storage Assets ---
variable "app_insights_connection_string" {
  type        = string
  description = "The connection string for Application Insights telemetry."
}

variable "app_insights_key" {
  type        = string
  description = "The Instrumentation Key for Application Insights."
}

variable "storage_url" {
  type        = string
  description = "The primary blob endpoint URL for serving product images and assets."
}
