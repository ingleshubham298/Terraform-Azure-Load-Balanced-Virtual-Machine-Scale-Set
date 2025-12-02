# ========================================
# Terraform Configuration
# ========================================
# This block defines the Terraform version and required providers

terraform {
  # Minimum Terraform version required to run this configuration
  required_version = ">= 1.5.7"

  # Azure Resource Manager (AzureRM) provider configuration
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official HashiCorp Azure provider
      version = "~> 3.0"            # Use version 3.x (allows minor updates)
    }
  }
}

# ========================================
# Azure Provider Configuration
# ========================================
# Configure the Azure provider with default features
provider "azurerm" {
  features {} # Required block for AzureRM provider (can be empty)
}

