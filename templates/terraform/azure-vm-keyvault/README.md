# Azure VM with Key Vault Terraform Template

This Terraform template deploys a complete Azure infrastructure including:
- Virtual Machine (Ubuntu 22.04 LTS)
- Storage Account with containers
- Key Vault for secure credential storage
- Virtual Network with subnet and NSG
- Resource Group

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Resource Group                     │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Virtual Network (VNet)                   │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │                 Subnet                          │  │  │
│  │  │                                                 │  │  │
│  │  │  ┌────────────────────┐     ┌──────────────┐   │  │  │
│  │  │  │  Virtual Machine   │     │    NSG       │   │  │  │
│  │  │  │  (Ubuntu 22.04)    │◄────┤ • SSH (22)   │   │  │  │
│  │  │  │  • Public IP       │     │ • HTTP (80)  │   │  │  │
│  │  │  │  • NIC             │     │ • HTTPS (443)│   │  │  │
│  │  │  └────────────────────┘     └──────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│                           │                  │              │
│                           │                  │              │
│  ┌────────────────────────▼──────┐  ┌────────▼──────────┐  │
│  │     Azure Key Vault           │  │ Storage Account   │  │
│  │  ┌─────────────────────────┐  │  │ • Blob Container  │  │
│  │  │ Secrets:                │  │  │ • Lifecycle Rules │  │
│  │  │ • vm-admin-username     │  │  │ • Access Policies │  │
│  │  │ • vm-admin-password     │  │  └───────────────────┘  │
│  │  │ • storage-account-key   │  │                         │
│  │  └─────────────────────────┘  │                         │
│  └────────────────────────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

## Features

- **Modular Design**: Each resource type is defined in its own module for reusability
- **Security**: VM credentials and storage account keys are automatically stored in Azure Key Vault
- **Random Password Generation**: VM admin password is automatically generated and secured
- **Cloud-Init**: VM is provisioned with Azure CLI and basic tools
- **Network Security**: NSG with rules for SSH, HTTP, and HTTPS access

## Prerequisites

1. Azure CLI installed and authenticated
2. Terraform >= 1.0 installed
3. Appropriate Azure permissions to create resources

## Quick Start

1. **Clone and navigate to the template directory**
   ```bash
   cd templates/terraform/azure-vm-keyvault
   ```

2. **Copy and customize the variables file**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit `terraform.tfvars` with your specific values (ensure storage account and key vault names are globally unique).

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Plan the deployment**
   ```bash
   terraform plan
   ```

5. **Apply the configuration**
   ```bash
   terraform apply
   ```

## Key Vault Secrets

After deployment, the following secrets are automatically stored in Azure Key Vault:

- `vm-admin-username`: Virtual machine admin username
- `vm-admin-password`: Virtual machine admin password (randomly generated)
- `storage-account-primary-key`: Primary access key for the storage account

## Accessing Your VM

1. **Get the public IP address**
   ```bash
   terraform output vm_public_ip
   ```

2. **Retrieve the admin password from Key Vault**
   ```bash
   az keyvault secret show --vault-name "your-keyvault-name" --name "vm-admin-password" --query value -o tsv
   ```

3. **SSH to the VM**
   ```bash
   ssh azureuser@<public-ip>
   ```

## Module Structure

```
modules/
├── resource_group/     # Azure Resource Group
├── network/           # VNet, Subnet, NSG
├── storage_account/   # Storage Account with containers
├── key_vault/         # Key Vault with access policies
└── virtual_machine/   # VM, NIC, Public IP with cloud-init
```

## Customization

### VM Configuration
Edit `modules/virtual_machine/variables.tf` to customize:
- VM size
- OS disk type
- VM image (currently Ubuntu 22.04 LTS)

### Storage Containers
Edit `modules/storage_account/variables.tf` to add/modify storage containers:
```hcl
containers = [
  {
    name        = "data"
    access_type = "private"
  },
  {
    name        = "logs"
    access_type = "private"
  }
]
```

### Network Security
Edit `modules/network/main.tf` to modify NSG rules for different port access.

## Clean Up

To destroy all resources:
```bash
terraform destroy
```

## Security Considerations

- VM password is randomly generated and stored securely in Key Vault
- Storage account keys are automatically stored in Key Vault
- Key Vault access is restricted to the current Azure user/service principal
- NSG rules can be customized based on security requirements
- Soft delete is enabled on Key Vault for accidental deletion protection

## Outputs

The template provides the following outputs:
- Resource group name
- Virtual network and subnet IDs
- Storage account name
- Key Vault ID and URI
- VM ID and IP addresses (public and private)

All sensitive outputs (passwords, keys) are marked as sensitive and will be masked in Terraform output.

## Project File Structure

terraform/azure-vm-keyvault/
├── main.tf                           # Main configuration with provider and module calls
├── variables.tf                      # Root-level variables
├── outputs.tf                        # Root-level outputs
├── terraform.tfvars.example          # Example variables file
├── README.md                         # Complete documentation
└── modules/
    ├── resource_group/               # Resource Group module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── network/                      # VNet, Subnet, NSG module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── storage_account/              # Storage Account module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── key_vault/                    # Key Vault module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── virtual_machine/              # VM, NIC, Public IP module
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── cloud-init.yaml          # VM initialization script

## Key Features

### **Security & Secrets Management:**
- **Random Password Generation**: VM admin password is automatically generated using `random_password`
- **Key Vault Integration**: All sensitive data is stored in Azure Key Vault:
  - VM admin username
  - VM admin password (randomly generated)
  - Storage account primary access key
- **Access Policies**: Key Vault configured with appropriate permissions for current user/service principal

### **Infrastructure Components:**
1. **Resource Group**: Container for all resources
2. **Virtual Network**: With subnet and Network Security Group (NSG)
3. **Storage Account**: With configurable containers and security settings
4. **Key Vault**: Secure storage for credentials and keys
5. **Virtual Machine**: Ubuntu 22.04 LTS with cloud-init configuration

### **Modular Design:**
- Each component is in its own module for reusability
- Modules have proper input/output definitions
- Dependencies are properly managed between modules

### **Security Features:**
- NSG with rules for SSH (22), HTTP (80), and HTTPS (443)
- Storage account with minimum TLS 1.2 and restricted public access
- Key Vault with soft delete enabled
- VM with Azure CLI pre-installed via cloud-init

### **Automated Deployment Features:**
- Dependency ordering (Key Vault created before secrets are stored)
- Secure credential generation and storage
- Network security configuration
- VM provisioning with essential tools
- All sensitive outputs marked as `sensitive = true` to prevent accidental exposure
