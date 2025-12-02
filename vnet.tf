# ========================================
# Virtual Network (VNet)
# ========================================
# Creates an Azure Virtual Network - the fundamental building block for private network in Azure
# This VNet will contain all subnets and network resources

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name                  # VNet name (e.g., "Project14-vnet")
  location            = var.location                   # Same region as resource group
  resource_group_name = azurerm_resource_group.rg.name # Parent resource group
  address_space       = var.vnet_address_space         # IP address range (e.g., ["10.0.0.0/16"])
}

# ========================================
# Subnet for Virtual Machines
# ========================================
# Creates a subnet within the VNet for hosting virtual machines
# VMs will receive private IP addresses from this subnet's address range

resource "azurerm_subnet" "vmss-subnet" {
  name                 = var.vmss_subnet_name              # Subnet name (e.g., "vmss-subnet")
  resource_group_name  = azurerm_resource_group.rg.name    # Parent resource group
  virtual_network_name = azurerm_virtual_network.vnet.name # Parent VNet
  address_prefixes     = [var.vmss_subnet_address_prefix]  # Subnet IP range (e.g., ["10.0.1.0/24"])
}


resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "vmss-nic" {
  subnet_id                 = azurerm_subnet.vmss-subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

