# ========================================
# VM1 - Network Interface Card (NIC)
# ========================================
# Creates a network interface for the first virtual machine
# This NIC connects the VM to the subnet and enables network communication

resource "azurerm_network_interface" "vmss-nic" {
  name                = "vm-nic"                           # NIC name
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
# VM1 - Backend Pool Association
# ========================================
# Associates VM1's NIC with the load balancer backend pool
# This allows the load balancer to distribute traffic to this VM

resource "azurerm_network_interface_backend_address_pool_association" "nic-backend" {
  network_interface_id    = azurerm_network_interface.vmss-nic.id      # NIC to associate
  ip_configuration_name   = "internal"                                 # IP config name from above
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id # Backend pool to join
}

# ========================================
# VM1 - NAT Rule Association for SSH
# ========================================
# Associates VM1's NIC with the SSH NAT rule
# This enables direct SSH access to VM1 via the load balancer's public IP on port 22

resource "azurerm_network_interface_nat_rule_association" "nic-nat" {
  network_interface_id  = azurerm_network_interface.vmss-nic.id # NIC to associate
  ip_configuration_name = "internal"                            # IP config name from above
  nat_rule_id           = azurerm_lb_nat_rule.nat-rule-ssh.id   # NAT rule for SSH access
}

# ========================================
# VM1 - Linux Virtual Machine
# ========================================
# Creates the first Ubuntu Linux virtual machine
# This VM will serve web traffic and is part of the load balancer backend pool

resource "azurerm_linux_virtual_machine" "lix-vm" {
  name                            = "project14-vm"                          # VM name
  resource_group_name             = azurerm_resource_group.rg.name          # Parent resource group
  location                        = azurerm_resource_group.rg.location      # Same region as resource group
  size                            = "Standard_b2ms"                         # VM size (2 vCPUs, 8GB RAM)
  admin_username                  = "adminuser"                             # Admin username for SSH login
  admin_password                  = "P@ssw0rd1234"                          # Admin password (consider using Azure Key Vault)
  disable_password_authentication = false                                   # Allow password authentication
  network_interface_ids           = [azurerm_network_interface.vmss-nic.id] # Attach the NIC created above

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
