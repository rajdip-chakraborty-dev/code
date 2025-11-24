# Infrastructure as Code (IaC) Templates Collection

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![GCP](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

A comprehensive, production-ready collection of **Infrastructure as Code templates** for multi-cloud deployments covering **AWS**, **Azure**, and **GCP**. This repository provides battle-tested templates for Terraform, Ansible, ARM Templates, Bicep, Packer, and DevOps CI/CD pipelines.

## 🎯 Overview

This repository is a complete IaC toolkit for cloud engineers, DevOps practitioners, and platform teams looking to:
- ✅ Automate infrastructure provisioning across multiple cloud providers
- ✅ Implement security best practices (KMS, Key Vault, Secrets Manager)
- ✅ Deploy scalable, repeatable infrastructure
- ✅ Accelerate cloud adoption with ready-to-use templates
- ✅ Establish CI/CD pipelines for infrastructure automation

## 📂 Repository Structure

```
templates/
├── terraform/          # Multi-cloud Terraform modules
│   ├── aws-vm-secrets/        # AWS EC2 + Secrets Manager
│   ├── azure-vm-keyvault/     # Azure VM + Key Vault
│   └── gcp-vm-kms/            # GCP Compute + Cloud KMS
├── ansible/           # Configuration management playbooks
├── arm/              # Azure Resource Manager templates
├── bicep/            # Azure Bicep templates
├── packer/           # VM image automation
└── devops/           # CI/CD pipeline configurations
    ├── azure-devops/
    ├── aws-devops/
    ├── github/
    └── jenkins/
```

## 🚀 Featured Templates

### 🔹 Terraform Multi-Cloud Solutions

#### 1. AWS Infrastructure with Secrets Manager
**Location**: [`templates/terraform/aws-vm-secrets/`](./templates/terraform/aws-vm-secrets/)

Complete AWS infrastructure deployment featuring:
- **EC2 Instance** with automated configuration
- **VPC Architecture** with public/private subnets
- **AWS Secrets Manager** for secure credential storage
- **S3 Bucket** with KMS encryption
- **IAM Roles** with least-privilege access

```bash
cd templates/terraform/aws-vm-secrets
terraform init && terraform apply
```

**Key Features:**
- 🔐 Automated password generation
- 🔒 Secrets Manager integration
- 📦 Encrypted S3 storage
- 🌐 Production-ready VPC design

---

#### 2. Azure VM with Key Vault
**Location**: [`templates/terraform/azure-vm-keyvault/`](./templates/terraform/azure-vm-keyvault/)

Azure infrastructure deployment with enterprise security:
- **Virtual Machine** (Ubuntu 22.04 LTS)
- **Azure Key Vault** for secrets management
- **Storage Account** with containers
- **Virtual Network** with NSG
- **Modular Design** for reusability

```bash
cd templates/terraform/azure-vm-keyvault
terraform init && terraform apply
```

**Key Features:**
- 🔑 Key Vault integration
- ☁️ Cloud-init automation
- 🏗️ Modular architecture
- 🔒 Network security groups

---

#### 3. GCP Compute with Cloud KMS
**Location**: [`templates/terraform/gcp-vm-kms/`](./templates/terraform/gcp-vm-kms/)

Google Cloud Platform infrastructure with encryption:
- **Compute Engine** instances
- **Cloud KMS** for encryption management
- **Cloud Storage** with versioning
- **VPC Network** with firewall rules
- **Service Accounts** with IAM

```bash
cd templates/terraform/gcp-vm-kms
terraform init && terraform apply
```

**Key Features:**
- 🔐 Cloud KMS encryption
- 🌐 Custom VPC with Cloud NAT
- 🔒 Service account IAM
- 📦 Versioned storage buckets

---

## 🏗️ Architecture Patterns

### Multi-Cloud Strategy
```
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure as Code                      │
│                                                             │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐          │
│  │    AWS    │    │   Azure   │    │    GCP    │          │
│  │           │    │           │    │           │          │
│  │  EC2+S3   │    │   VM+KV   │    │  GCE+GCS  │          │
│  │  Secrets  │    │  KeyVault │    │    KMS    │          │
│  └───────────┘    └───────────┘    └───────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                         │
                         ▼
              ┌────────────────────┐
              │  Unified Templates │
              │   • Terraform      │
              │   • Ansible        │
              │   • CI/CD          │
              └────────────────────┘
```

## 📋 Prerequisites

| Tool | Minimum Version | Purpose |
|------|----------------|---------|
| **Terraform** | >= 1.0 | Infrastructure provisioning |
| **Ansible** | >= 2.9 | Configuration management |
| **Azure CLI** | >= 2.30 | Azure resource management |
| **AWS CLI** | >= 2.0 | AWS resource management |
| **gcloud SDK** | Latest | GCP resource management |

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/rajdip-chakraborty-dev/code.git
cd code/templates
```

### 2. Choose Your Template

```bash
# AWS Deployment
cd terraform/aws-vm-secrets

# Azure Deployment
cd terraform/azure-vm-keyvault

# GCP Deployment
cd terraform/gcp-vm-kms
```

### 3. Configure Variables

```bash
# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

## 🔐 Security Best Practices

All templates implement security best practices:

### Secrets Management
- ✅ **No hardcoded credentials** - All secrets generated dynamically
- ✅ **Cloud-native secret stores** - Secrets Manager, Key Vault, KMS
- ✅ **IAM integration** - Service accounts with least privilege
- ✅ **Encryption at rest** - KMS/CMK for all sensitive data

### Network Security
- ✅ **Network segmentation** - Public/private subnet separation
- ✅ **Security groups** - Principle of least privilege
- ✅ **Firewall rules** - Explicit allow/deny policies
- ✅ **NAT Gateways** - Secure internet access for private resources

## 📊 Template Comparison

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| **Compute** | EC2 | Virtual Machine | Compute Engine |
| **Storage** | S3 | Storage Account | Cloud Storage |
| **Secrets** | Secrets Manager | Key Vault | Cloud KMS |
| **Network** | VPC | Virtual Network | VPC Network |
| **IAM** | IAM Roles | Managed Identity | Service Account |

## 🔄 CI/CD Integration

### Azure DevOps Pipeline Example

See [`templates/devops/azure-devops/azure-pipelines-aks.yml`](./templates/devops/azure-devops/azure-pipelines-aks.yml) for complete pipeline configuration.

```yaml
stages:
- stage: Plan
  jobs:
  - job: TerraformPlan
    steps:
    - task: TerraformInstaller@0
    - task: TerraformTaskV2@2
      inputs:
        command: 'plan'

- stage: Apply
  dependsOn: Plan
  jobs:
  - deployment: TerraformApply
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: TerraformTaskV2@2
            inputs:
              command: 'apply'
```

## 🧪 Testing & Validation

```bash
# Terraform validation
terraform fmt -check -recursive
terraform validate

# Security scanning
tfsec .

# Cost estimation
infracost breakdown --path .
```

## 📚 Documentation

Each template includes:
- 📖 **Comprehensive README** - Setup and deployment instructions
- 🏗️ **Architecture diagrams** - Visual infrastructure layout
- 🔧 **Variable descriptions** - All configurable parameters
- 📤 **Output definitions** - Resource identifiers and endpoints
- 🎯 **Use case examples** - Real-world scenarios
- 🔍 **Troubleshooting guide** - Common issues and solutions

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Follow existing patterns
4. Add comprehensive documentation
5. Test thoroughly
6. Submit a pull request

## 🌟 Use Cases

### Enterprise Deployment
- Multi-region infrastructure
- High availability setup
- Disaster recovery configuration
- Compliance and governance

### Development Environment
- Isolated dev/test environments
- Cost-optimized configurations
- Rapid provisioning/teardown
- CI/CD integration

### Migration Projects
- Lift-and-shift strategies
- Cloud-native transformation
- Multi-cloud deployments
- Hybrid cloud setups

## 📄 License

This repository is open source and available under standard licensing terms.

## 👤 Author

**Rajdip Chakraborty**
- **GitHub**: [@rajdip-chakraborty-dev](https://github.com/rajdip-chakraborty-dev)
- **LinkedIn**: [Rajdip Chakraborty](https://www.linkedin.com/in/rajdip-chakraborty)
- **Focus**: Cloud Infrastructure, DevOps, Multi-Cloud Automation

## ⭐ Show Your Support

If you find these templates helpful:
- ⭐ **Star this repository**
- 🔄 **Share with your team**
- 🐛 **Report issues**
- 💡 **Suggest improvements**
- 🤝 **Contribute templates**

---

## 🔖 Topics

`terraform` `ansible` `aws` `azure` `gcp` `infrastructure-as-code` `devops` `cloud-automation` `kubernetes` `ci-cd` `arm-templates` `bicep` `packer` `multi-cloud` `secrets-management`

---

**Built with ❤️ for the DevOps and Cloud Engineering community**
