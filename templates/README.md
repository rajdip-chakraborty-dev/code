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

#### AWS Infrastructure with Secrets Manager
**Location**: `terraform/aws-vm-secrets/`

Complete AWS infrastructure deployment featuring:
- **EC2 Instance**: Amazon Linux 2 or Ubuntu with custom user data
- **VPC Architecture**: Public/private subnets, Internet Gateway, NAT Gateway
- **Security Groups**: Layered security for EC2, RDS, and ALB
- **AWS Secrets Manager**: Automated credential generation and secure storage
- **S3 Bucket**: Encrypted storage with lifecycle policies
- **IAM Roles**: Least-privilege access policies

**Quick Deploy:**
```bash
cd terraform/aws-vm-secrets
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

**Key Features:**
- 🔐 Automated password generation with `random_password`
- 🔒 Secrets Manager integration for credentials
- 📦 S3 with KMS encryption
- 🌐 Production-ready VPC design
- 📝 Comprehensive documentation

---

#### Azure VM with Key Vault
**Location**: `terraform/azure-vm-keyvault/`

Azure infrastructure deployment with enterprise security:
- **Virtual Machine**: Ubuntu 22.04 LTS with cloud-init
- **Azure Key Vault**: Centralized secrets management
- **Storage Account**: Blob storage with containers
- **Virtual Network**: VNet, subnet, and NSG configuration
- **Modular Design**: Reusable Terraform modules

**Quick Deploy:**
```bash
cd terraform/azure-vm-keyvault
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

**Key Features:**
- 🔑 Key Vault integration for VM credentials
- ☁️ Cloud-init automation
- 🏗️ Modular architecture for reusability
- 🔒 Network Security Groups
- 📊 Output values for easy integration

---

#### GCP Compute with Cloud KMS
**Location**: `terraform/gcp-vm-kms/`

Google Cloud Platform infrastructure with encryption:
- **Compute Engine**: Ubuntu/Debian instances
- **Cloud KMS**: Multi-key encryption management
- **Cloud Storage**: KMS-encrypted buckets
- **VPC Network**: Custom networks with firewall rules
- **Service Accounts**: IAM roles and permissions

**Quick Deploy:**
```bash
cd terraform/gcp-vm-kms
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

**Key Features:**
- 🔐 Cloud KMS for encryption at rest
- 🌐 Custom VPC with Cloud NAT
- 🔒 Service account IAM integration
- 📦 Versioned storage buckets
- 🚀 Startup scripts automation

---

### 🔹 Ansible Configuration Management

**Location**: `ansible/`

Ansible playbooks for:
- Server configuration and hardening
- Application deployment automation
- Multi-tier application setup
- Cloud resource provisioning
- Security compliance automation

---

### 🔹 Azure Resource Manager (ARM) Templates

**Location**: `arm/`

Native Azure infrastructure templates:
- Virtual machines and scale sets
- App Services and Functions
- Azure Kubernetes Service (AKS)
- Network infrastructure
- Storage accounts and databases

---

### 🔹 Azure Bicep Templates

**Location**: `bicep/`

Modern Azure IaC with Bicep:
- Simplified ARM template syntax
- Modular resource definitions
- Azure best practices
- Type-safe configurations

---

### 🔹 Packer Image Automation

**Location**: `packer/`

Automated VM image creation:
- AWS AMI building
- Azure managed images
- GCP custom images
- Docker container images
- Multi-cloud image pipelines

---

### 🔹 DevOps CI/CD Pipelines

**Location**: `devops/`

Complete CI/CD pipeline configurations:

#### Azure DevOps
- **AKS Deployments**: `devops/azure-devops/azure-pipelines-aks.yml`
- Terraform plan/apply automation
- Multi-stage deployments
- Environment approvals

#### GitHub Actions
- Infrastructure deployment workflows
- Terraform validation and testing
- Security scanning integration

#### Jenkins
- Declarative pipelines
- Infrastructure provisioning
- Automated testing

#### AWS DevOps
- CodePipeline configurations
- CodeBuild specifications
- CloudFormation integration

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

### Required Tools

| Tool | Minimum Version | Purpose |
|------|----------------|---------|
| **Terraform** | >= 1.0 | Infrastructure provisioning |
| **Ansible** | >= 2.9 | Configuration management |
| **Azure CLI** | >= 2.30 | Azure resource management |
| **AWS CLI** | >= 2.0 | AWS resource management |
| **gcloud SDK** | Latest | GCP resource management |
| **Packer** | >= 1.7 | Image automation |
| **Docker** | >= 20.x | Container management |

### Cloud Accounts

- ✅ AWS Account with appropriate IAM permissions
- ✅ Azure Subscription with Contributor role
- ✅ GCP Project with required APIs enabled
- ✅ Service principals/credentials configured

## 🚀 Quick Start Guide

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
nano terraform.tfvars  # or use your preferred editor
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

### 5. Verify Deployment

```bash
# View outputs
terraform output

# Test connectivity
# (Follow template-specific testing instructions)
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

### Access Control
- ✅ **IAM roles** - Identity-based access control
- ✅ **Service accounts** - Workload identity
- ✅ **MFA enforcement** - Multi-factor authentication
- ✅ **Audit logging** - CloudTrail, Activity Log, Cloud Audit

## 📊 Template Comparison

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| **Compute** | EC2 | Virtual Machine | Compute Engine |
| **Storage** | S3 | Storage Account | Cloud Storage |
| **Secrets** | Secrets Manager | Key Vault | Cloud KMS |
| **Network** | VPC | Virtual Network | VPC Network |
| **IAM** | IAM Roles | Managed Identity | Service Account |
| **Encryption** | KMS | Key Vault Keys | Cloud KMS |

## 🎓 Learning Paths

### Beginner
1. Start with single-VM deployments
2. Understand variable configuration
3. Explore output values
4. Practice with `terraform plan`

### Intermediate
1. Modify existing modules
2. Customize security groups/firewall rules
3. Add monitoring and logging
4. Implement multi-region deployments

### Advanced
1. Create custom modules
2. Implement GitOps workflows
3. Multi-cloud orchestration
4. Advanced networking (VPN, peering)

## 🔄 CI/CD Integration

### Terraform Automation

```yaml
# Example: Azure DevOps Pipeline
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - terraform/**

stages:
- stage: Plan
  jobs:
  - job: TerraformPlan
    steps:
    - task: TerraformInstaller@0
    - task: TerraformTaskV2@2
      inputs:
        command: 'init'
    - task: TerraformTaskV2@2
      inputs:
        command: 'plan'

- stage: Apply
  dependsOn: Plan
  condition: succeeded()
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

### Terraform Validation

```bash
# Format check
terraform fmt -check -recursive

# Validation
terraform validate

# Security scanning
tfsec .

# Cost estimation
infracost breakdown --path .
```

### Ansible Testing

```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check

# Lint
ansible-lint playbook.yml
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

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-template`)
3. **Follow existing patterns** - Maintain consistency
4. **Add documentation** - Update README files
5. **Test thoroughly** - Validate all templates
6. **Submit a pull request** - Describe your changes

### Template Standards

- ✅ Use `.tfvars.example` for variable examples
- ✅ Include comprehensive README with quickstart
- ✅ Add architecture diagrams where applicable
- ✅ Document all variables and outputs
- ✅ Follow cloud provider best practices
- ✅ Include cleanup instructions

## 📄 License

This repository is open source and available under standard licensing terms. See individual template licenses for specific details.

## 👤 Author

**Rajdip Chakraborty**
- **GitHub**: [@rajdip-chakraborty-dev](https://github.com/rajdip-chakraborty-dev)
- **LinkedIn**: [Rajdip Chakraborty](https://www.linkedin.com/in/rajdip-chakraborty)
- **Focus**: Cloud Infrastructure, DevOps, Multi-Cloud Automation

## 🌟 Featured Use Cases

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

## 🔖 Tags & Topics

`terraform` `ansible` `aws` `azure` `gcp` `infrastructure-as-code` `devops` `cloud-automation` `kubernetes` `ci-cd` `arm-templates` `bicep` `packer` `multi-cloud` `secrets-management` `security` `networking`

## ⭐ Show Your Support

If you find these templates helpful:
- ⭐ **Star this repository**
- 🔄 **Share with your team**
- 🐛 **Report issues**
- 💡 **Suggest improvements**
- 🤝 **Contribute templates**

---

## 📞 Support & Community

- 📫 **Issues**: Report bugs or request features via GitHub Issues
- 💬 **Discussions**: Join community discussions
- 📖 **Wiki**: Additional documentation and guides
- 🎓 **Tutorials**: Step-by-step deployment guides

---

**Built with ❤️ for the DevOps and Cloud Engineering community**

Last Updated: November 2025
