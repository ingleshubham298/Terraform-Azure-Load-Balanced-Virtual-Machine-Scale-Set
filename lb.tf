# ========================================
# Azure Load Balancer
# ========================================
# Creates a Standard SKU Load Balancer to distribute incoming traffic across multiple VMs
# This provides high availability and scalability for your application

resource "azurerm_lb" "lb" {
  name                = var.lb_name                    # Load balancer name (e.g., "Project14-lb")
  location            = var.location                   # Same region as resource group
  resource_group_name = azurerm_resource_group.rg.name # Parent resource group
  sku                 = "Standard"                     # Standard SKU for production workloads

  # Frontend IP configuration - the public-facing IP of the load balancer
  frontend_ip_configuration {
    name                 = "FE-IP"                     # Frontend IP configuration name
    public_ip_address_id = azurerm_public_ip.lb-pip.id # Associates the public IP created earlier
  }
}

# ========================================
# Load Balancer Backend Address Pool
# ========================================
# Creates a backend pool that contains the VMs receiving traffic from the load balancer
# VMs are added to this pool via NIC associations

resource "azurerm_lb_backend_address_pool" "backend" {
  name            = "BE-POOL"        # Backend pool name
  loadbalancer_id = azurerm_lb.lb.id # Parent load balancer
}

# ========================================
# Load Balancer Rule - HTTP Traffic
# ========================================
# Defines how traffic is distributed from frontend to backend
# This rule forwards HTTP traffic (port 80) to backend VMs

resource "azurerm_lb_rule" "rule-http" {
  name                           = "HTTP"                                       # Rule name
  loadbalancer_id                = azurerm_lb.lb.id                             # Parent load balancer
  protocol                       = "Tcp"                                        # TCP protocol
  frontend_port                  = 80                                           # Port on load balancer (internet-facing)
  backend_port                   = 80                                           # Port on backend VMs
  frontend_ip_configuration_name = "FE-IP"                                      # Frontend IP to use
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend.id] # Backend pool to send traffic to
  probe_id                       = azurerm_lb_probe.http.id                     # Health probe to check VM status
}

# ========================================
# Load Balancer Health Probe
# ========================================
# Monitors the health of backend VMs by sending HTTP requests
# Only healthy VMs (responding to probe) receive traffic from the load balancer

resource "azurerm_lb_probe" "http" {
  name                = "HTTP"           # Probe name
  loadbalancer_id     = azurerm_lb.lb.id # Parent load balancer
  protocol            = "Http"           # HTTP protocol for health check
  port                = 80               # Port to probe on backend VMs
  request_path        = "/"              # HTTP path to check (root path)
  interval_in_seconds = 15               # Check every 15 seconds
  number_of_probes    = 2                # Number of consecutive failures before marking unhealthy
  probe_threshold     = 1                # Number of consecutive successes before marking healthy
}

# ========================================
# Load Balancer NAT Rule - SSH Access
# ========================================
# Creates a NAT rule to allow direct SSH access to a specific VM
# Maps port 22 on the load balancer's public IP to port 22 on the backend VM

resource "azurerm_lb_nat_rule" "nat-rule-ssh" {
  name                           = "SSH" # NAT rule name
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id # Parent load balancer
  frontend_ip_configuration_name = "FE-IP"          # Frontend IP to use
  protocol                       = "Tcp"            # TCP protocol
  frontend_port                  = 22               # Port on load balancer (for SSH access)
  backend_port                   = 22               # Port on backend VM (SSH default port)
}
