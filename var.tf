# ========================================
# Variable Definitions
# ========================================
# This file defines all input variables used across the Terraform configuration
# Variables allow you to customize deployments without modifying the actual resource code

# ========================================
# General Configuration Variables
# ========================================

# Azure region where all resources will be deployed
variable "location" {
  type        = string
  default     = "centralindia"
  description = "Azure region for resource deployment (e.g., centralindia, eastus, westeurope)"
}

# Name of the resource group that will contain all resources
variable "resource_group_name" {
  type        = string
  default     = "Project14-rg"
  description = "Name of the Azure Resource Group"
}

# ========================================
# Network Configuration Variables
# ========================================

# Virtual Network name
variable "vnet_name" {
  type        = string
  default     = "Project14-vnet"
  description = "Name of the Azure Virtual Network"
}

# Virtual Network address space (CIDR notation)
variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the Virtual Network (supports up to 65,536 IP addresses)"
}

# Subnet name for virtual machines
variable "vmss_subnet_name" {
  type        = string
  default     = "vmss-subnet"
  description = "Name of the subnet for virtual machines"
}

# Subnet address prefix (CIDR notation)
variable "vmss_subnet_address_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Address prefix for the VM subnet (supports up to 256 IP addresses)"
}

# ========================================
# Security Configuration Variables
# ========================================

# Network Security Group name
variable "nsg_name" {
  type        = string
  default     = "vmss-nsg"
  description = "Name of the Network Security Group for firewall rules"
}

# ========================================
# Load Balancer Configuration Variables
# ========================================

# Public IP name for the load balancer
variable "lb_pip_name" {
  type        = string
  default     = "Project14-lb-pip"
  description = "Name of the public IP address for the load balancer"
}

# Load Balancer name
variable "lb_name" {
  type        = string
  default     = "Project14-lb"
  description = "Name of the Azure Load Balancer"
}
