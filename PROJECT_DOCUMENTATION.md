# Project14 - Azure Load-Balanced Web Application Infrastructure

## Project Overview

This project implements a **highly available, load-balanced web application infrastructure** on Microsoft Azure using Infrastructure as Code (IaC) with Terraform. The infrastructure consists of two Ubuntu Linux virtual machines behind an Azure Standard Load Balancer, providing redundancy, scalability, and high availability for web applications.

## Architecture Summary

### **Infrastructure Components**

1. **Resource Group** - Logical container for all Azure resources in Central India region
2. **Virtual Network (VNet)** - Private network with 10.0.0.0/16 address space
3. **Subnet** - VM subnet with 10.0.1.0/24 address range
4. **Load Balancer** - Standard SKU Azure Load Balancer for traffic distribution
5. **Public IP** - Static public IP address for internet-facing access
6. **Virtual Machines** - Two Ubuntu 22.04 LTS VMs (Standard_B2ms)
7. **Network Security Groups** - Firewall rules for traffic control

### **Key Features**

- ✅ **High Availability** - Multiple VMs behind load balancer ensure uptime
- ✅ **Auto-Scaling Ready** - Infrastructure designed for easy horizontal scaling
- ✅ **Health Monitoring** - HTTP health probes detect and route around failed instances
- ✅ **Secure Access** - NAT rules for SSH access, NSG for traffic filtering
- ✅ **Infrastructure as Code** - Fully automated deployment with Terraform
- ✅ **Cloud-Init Support** - Automated VM configuration via user-data scripts

## Technical Specifications

### **Compute Resources**
- **VM Count**: 2 Linux virtual machines
- **VM Size**: Standard_B2ms (2 vCPUs, 8GB RAM)
- **Operating System**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **Storage**: Standard LRS (Locally Redundant Storage)

### **Network Configuration**
- **VNet Address Space**: 10.0.0.0/16 (65,536 IP addresses)
- **Subnet Range**: 10.0.1.0/24 (256 IP addresses)
- **Load Balancer SKU**: Standard
- **Public IP**: Static allocation, Standard SKU

### **Load Balancing**
- **Frontend Port**: 80 (HTTP)
- **Backend Port**: 80 (HTTP)
- **Health Probe**: HTTP on port 80, path "/"
- **Probe Interval**: 15 seconds
- **SSH Access**: NAT rule on port 22 for VM1

## Infrastructure Diagram

```
Internet
    |
    v
[Public IP: Static]
    |
    v
[Azure Load Balancer]
    |
    +-- Health Probe (HTTP:80)
    |
    +-- Backend Pool
         |
         +-- [VM1: project14-vm]
         |    - NIC: vm-nic
         |    - Private IP: Dynamic (10.0.1.x)
         |    - SSH NAT Rule: Port 22
         |
         +-- [VM2: project14-vm1]
              - NIC: vm-nic1
              - Private IP: Dynamic (10.0.1.x)
              - NSG: Allow HTTP (Port 80)
```

## File Structure

```
Project14/
├── provider.tf          # Terraform and Azure provider configuration
├── var.tf              # Variable definitions
├── rg.tf               # Resource Group
├── vnet.tf             # Virtual Network and Subnet
├── lbpip.tf            # Load Balancer Public IP
├── lb.tf               # Load Balancer, Backend Pool, Rules, Probes
├── vm1.tf              # First Virtual Machine and NIC
├── vm2.tf              # Second Virtual Machine and NIC
├── outpu.tf            # Output values
└── user-data.sh        # Cloud-init script for VM configuration
```

## Deployment Process

### **Prerequisites**
- Terraform >= 1.5.7
- Azure CLI configured with valid credentials
- Azure subscription with appropriate permissions

### **Deployment Steps**

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Validate Configuration**
   ```bash
   terraform validate
   ```

3. **Review Execution Plan**
   ```bash
   terraform plan
   ```

4. **Deploy Infrastructure**
   ```bash
   terraform apply
   ```

5. **Access Application**
   ```bash
   # Get the public IP address
   terraform output lb_pip_ip
   
   # Access via browser
   http://<public-ip-address>
   ```

## Security Considerations

### **Network Security**
- VMs are in a private subnet (no direct internet access)
- All internet traffic flows through the load balancer
- Network Security Groups control inbound/outbound traffic
- SSH access restricted via NAT rules

### **Access Control**
- **VM1**: SSH access via load balancer NAT rule (port 22)
- **VM2**: HTTP access only (port 80), separate NSG
- Password authentication enabled (consider using SSH keys in production)

### **Recommendations for Production**
- ⚠️ Store passwords in Azure Key Vault
- ⚠️ Use SSH keys instead of password authentication
- ⚠️ Implement Azure Bastion for secure VM access
- ⚠️ Enable Azure Monitor and Log Analytics
- ⚠️ Configure backup policies for VMs

## Use Cases

This infrastructure is suitable for:

- **Web Applications** - Host scalable web servers (Apache, Nginx)
- **API Services** - Deploy RESTful APIs with load balancing
- **Microservices** - Run containerized applications
- **Development/Testing** - Test load-balanced architectures
- **Learning Platform** - Understand Azure networking and Terraform

## Cost Optimization

**Estimated Monthly Cost** (Central India region):
- 2x Standard_B2ms VMs: ~$60-80/month
- Standard Load Balancer: ~$18/month
- Public IP: ~$3/month
- Storage: ~$5/month
- **Total**: ~$86-106/month (approximate)

**Cost Saving Tips**:
- Use Azure Reserved Instances for VMs (up to 72% savings)
- Stop VMs during non-business hours
- Use B-series burstable VMs for variable workloads
- Monitor and optimize with Azure Cost Management

## Outputs

After deployment, Terraform provides these outputs:

| Output | Description |
|--------|-------------|
| `rg_name` | Resource group name |
| `vnet_name` | Virtual network name |
| `vnet_address_space` | VNet CIDR blocks |
| `vmss_subnet_name` | Subnet name |
| `lb_name` | Load balancer name |
| `lb_pip_ip` | **Public IP to access application** |
| `lb_pip_fqdn` | Fully qualified domain name (if configured) |

## Maintenance and Operations

### **Scaling**
- Add more VMs by duplicating vm2.tf with unique names
- VMs automatically join the backend pool
- Load balancer distributes traffic across all healthy instances

### **Monitoring**
- Check VM health via Azure Portal
- Monitor load balancer metrics (connections, throughput)
- Review NSG flow logs for security analysis

### **Updates**
- Modify variables in `var.tf` for configuration changes
- Run `terraform plan` to preview changes
- Apply updates with `terraform apply`

## Troubleshooting

### **Common Issues**

1. **Cannot access application via public IP**
   - Verify VMs are running
   - Check health probe status
   - Ensure user-data.sh installed web server
   - Verify NSG rules allow port 80

2. **SSH connection fails**
   - Confirm NAT rule is associated with VM1
   - Check NSG allows port 22
   - Verify correct public IP and credentials

3. **Terraform errors**
   - Run `terraform init` after provider changes
   - Validate syntax with `terraform validate`
   - Check Azure credentials are configured

## Future Enhancements

- [ ] Implement Azure Application Gateway for Layer 7 load balancing
- [ ] Add Azure Bastion for secure VM access
- [ ] Configure auto-scaling with VM Scale Sets
- [ ] Implement Azure Monitor and alerts
- [ ] Add SSL/TLS termination at load balancer
- [ ] Integrate with Azure DevOps for CI/CD
- [ ] Implement backup and disaster recovery

## Author & Version

- **Project**: Project14 - Azure Load-Balanced Infrastructure
- **IaC Tool**: Terraform
- **Cloud Provider**: Microsoft Azure
- **Region**: Central India
- **Last Updated**: December 2025

---

**Note**: This is a learning/development infrastructure. For production deployments, implement additional security hardening, monitoring, and compliance requirements specific to your organization.
