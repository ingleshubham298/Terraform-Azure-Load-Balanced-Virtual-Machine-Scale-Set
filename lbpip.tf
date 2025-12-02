# ========================================
# Public IP Address for Load Balancer
# ========================================
# Creates a static public IP address that will be assigned to the load balancer
# This is the IP address users will connect to from the internet

resource "azurerm_public_ip" "lb-pip" {
  name                = var.lb_pip_name                # Public IP name (e.g., "Project14-lb-pip")
  location            = var.location                   # Same region as resource group
  resource_group_name = azurerm_resource_group.rg.name # Parent resource group
  allocation_method   = "Static"                       # Static IP (doesn't change on restart)
  sku                 = "Standard"                     # Standard SKU required for Standard Load Balancer

  # Lifecycle configuration (optional)
  lifecycle {
    # prevent_destroy = true  # Uncomment to prevent accidental deletion of this public IP
  }
}
