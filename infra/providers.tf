# --------------------------------------------------------------------------
# Project:     eShopOnWeb Infrastructure
# File:        providers.tf
# Description: Configures the Terraform providers and requirements. 
#              The azurerm provider allows Terraform to manage resources 
#              on the Azure Cloud Platform.
# 
# Creator:     Chamseddine Boughanmi
# Email:       chamseddine.boughanmi@esprit.tn
# --------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3.0" # Best practice: Define the CLI version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Constrains to version 3.x for stability
    }
  }
}

provider "azurerm" {
  # The features block is required even if no specific features are toggled.
  features {
    resource_group {
      # Useful for development: allows 'terraform destroy' to remove 
      # the RG even if it contains manually created resources.
      prevent_deletion_if_contains_resources = false
    }
  }
  
  # Note: Authentication is handled automatically via 'az login' 
  # or Service Principal environment variables.
}
