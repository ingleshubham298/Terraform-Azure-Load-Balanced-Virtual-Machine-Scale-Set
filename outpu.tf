# ========================================
# Terraform Output Values
# ========================================
# Outputs display useful information after Terraform applies the configuration
# These values can be used by other Terraform configurations or displayed to users
# Access outputs with: terraform output <output_name>

# ========================================
# Resource Group Outputs
# ========================================

# Name of the created resource group
output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the Azure Resource Group"
}

# ========================================
# Virtual Network Outputs
# ========================================

# Name of the virtual network
output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the Azure Virtual Network"
}

# Address space of the virtual network
output "vnet_address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "The address space (CIDR blocks) of the Virtual Network"
}

# ========================================
# Subnet Outputs
# ========================================

# Name of the VM subnet
output "vmss_subnet_name" {
  value       = azurerm_subnet.vmss-subnet.name
  description = "The name of the subnet for virtual machines"
}

# Address prefixes of the VM subnet
output "vmss_subnet_address_prefix" {
  value       = azurerm_subnet.vmss-subnet.address_prefixes
  description = "The address prefixes (CIDR blocks) of the VM subnet"
}

# ========================================
# Load Balancer Outputs
# ========================================

# Name of the load balancer
output "lb_name" {
  value       = azurerm_lb.lb.name
  description = "The name of the Azure Load Balancer"
}

# Name of the load balancer's public IP
output "lb_pip_name" {
  value       = azurerm_public_ip.lb-pip.name
  description = "The name of the load balancer's public IP address"
}

# Public IP address of the load balancer (use this to access your application)
output "lb_pip_ip" {
  value       = azurerm_public_ip.lb-pip.ip_address
  description = "The public IP address of the load balancer - use this to access your web application"
}

# Fully Qualified Domain Name (FQDN) of the load balancer's public IP
output "lb_pip_fqdn" {
  value       = azurerm_public_ip.lb-pip.fqdn
  description = "The FQDN of the load balancer's public IP (if DNS label is configured)"
}

# ========================================
# Virtual Machine Outputs
# ========================================
# Note: VM outputs are currently commented out due to incorrect resource references
# Uncomment and fix the resource names when needed

# # Name of the first virtual machine
# output "vm_name" {
#   value       = azurerm_linux_virtual_machine.lix-vm.name
#   description = "The name of the first Linux virtual machine"
# }

# # Admin username for VM access
# output "vm_admin_username" {
#   value       = azurerm_linux_virtual_machine.lix-vm.admin_username
#   description = "The admin username for SSH access to the VM"
# }

# # Admin password for VM access (SENSITIVE - will be hidden in output)
# output "vm_admin_password" {
#   value       = azurerm_linux_virtual_machine.lix-vm.admin_password
#   description = "The admin password for the VM"
#   sensitive   = true  # Marks this output as sensitive (won't be displayed in logs)
# }
