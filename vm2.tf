# ========================================
# VM2 - Network Interface Card (NIC)
# ========================================
# Creates a network interface for the second virtual machine
# This NIC connects VM2 to the subnet and enables network communication

resource "azurerm_network_interface" "vmss-nic1" {
  name                = "vm-nic1"                          # NIC name
  location            = azurerm_resource_group.rg.location # Same region as resource group
  resource_group_name = azurerm_resource_group.rg.name     # Parent resource group

  # IP configuration for the NIC
  ip_configuration {
    name                          = "internal"                    # IP configuration name
    subnet_id                     = azurerm_subnet.vmss-subnet.id # Subnet to attach to
    private_ip_address_allocation = "Dynamic"                     # Azure assigns IP automatically
  }
}

# ========================================
# VM2 - Backend Pool Association
# ========================================
# Associates VM2's NIC with the load balancer backend pool
# This allows the load balancer to distribute traffic to this VM

resource "azurerm_network_interface_backend_address_pool_association" "nic-backend1" {
  network_interface_id    = azurerm_network_interface.vmss-nic1.id     # NIC to associate
  ip_configuration_name   = "internal"                                 # IP config name from above
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id # Backend pool to join
}

# ========================================
# VM2 - NAT Rule Association (Commented Out)
# ========================================
# NAT rule association is commented out for VM2
# Only VM1 has direct SSH access via the load balancer NAT rule
# To enable SSH for VM2, uncomment this block and create a separate NAT rule with a different frontend port

# resource "azurerm_network_interface_nat_rule_association" "nic-nat1" {
#   network_interface_id  = azurerm_network_interface.vmss-nic1.id
#   ip_configuration_name = "internal"
#   nat_rule_id           = azurerm_lb_nat_rule.nat-rule-ssh.id
# }

# ========================================
# VM2 - Network Security Group (NSG)
# ========================================
# Creates a dedicated Network Security Group for VM2
# NSG acts as a virtual firewall to control inbound and outbound traffic

resource "azurerm_network_security_group" "vmss-nsg1" {
  name                = "vmss-nsg1"                        # NSG name
  location            = azurerm_resource_group.rg.location # Same region as resource group
  resource_group_name = azurerm_resource_group.rg.name     # Parent resource group

  # Security rule to allow HTTP traffic
  security_rule {
    name                       = "test123" # Rule name
    priority                   = 100       # Lower number = higher priority (100-4096)
    direction                  = "Inbound" # Applies to incoming traffic
    access                     = "Allow"   # Allow or Deny
    protocol                   = "Tcp"     # TCP protocol
    source_port_range          = "*"       # Any source port
    destination_port_range     = "80"      # Allow HTTP (port 80)
    source_address_prefix      = "*"       # Allow from any source IP
    destination_address_prefix = "*"       # To any destination IP
  }
}

# ========================================
# VM2 - NSG Association
# ========================================
# Associates the Network Security Group with VM2's NIC
# This applies the firewall rules to VM2's network interface

resource "azurerm_network_interface_security_group_association" "nic-nsg1" {
  network_interface_id      = azurerm_network_interface.vmss-nic1.id      # NIC to protect
  network_security_group_id = azurerm_network_security_group.vmss-nsg1.id # NSG to apply
}

# ========================================
# VM2 - Linux Virtual Machine
# ========================================
# Creates the second Ubuntu Linux virtual machine
# This VM will serve web traffic and is part of the load balancer backend pool

resource "azurerm_linux_virtual_machine" "lix-vm1" {
  name                            = "project14-vm1"                          # VM name
  resource_group_name             = azurerm_resource_group.rg.name           # Parent resource group
  location                        = azurerm_resource_group.rg.location       # Same region as resource group
  size                            = "Standard_b2ms"                          # VM size (2 vCPUs, 8GB RAM)
  admin_username                  = "adminuser"                              # Admin username for SSH login
  admin_password                  = "Password@123"                           # Admin password (consider using Azure Key Vault)
  disable_password_authentication = false                                    # Allow password authentication
  network_interface_ids           = [azurerm_network_interface.vmss-nic1.id] # Attach the NIC created above

  # Custom data - runs user-data.sh script on first boot (cloud-init)
  custom_data = base64encode(file("user-data.sh"))

  # OS Disk configuration
  os_disk {
    caching              = "ReadWrite"    # Enable read/write caching for better performance
    storage_account_type = "Standard_LRS" # Standard locally-redundant storage
  }

  # Source image - Ubuntu 22.04 LTS from Canonical
  source_image_reference {
    publisher = "Canonical"                    # Image publisher
    offer     = "0001-com-ubuntu-server-jammy" # Ubuntu Server 22.04 (Jammy)
    sku       = "22_04-lts"                    # Ubuntu 22.04 LTS SKU
    version   = "latest"                       # Always use latest patch version
  }
}
