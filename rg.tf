# ========================================
# Resource Group
# ========================================
# Creates an Azure Resource Group - a logical container for all Azure resources
# All resources in this project will be deployed within this resource group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name # Name from variables (e.g., "Project14-rg")
  location = var.location            # Azure region (e.g., "centralindia")
}
