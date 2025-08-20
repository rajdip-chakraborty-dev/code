# AWS Infrastructure with Terraform - EC2, S3, and Secrets Manager

This Terraform template deploys a complete AWS infrastructure including:
- **EC2 Instance** (Amazon Linux 2 or Ubuntu)
- **S3 Bucket** with encryption and lifecycle policies
- **AWS Secrets Manager** for secure credential storage
- **VPC** with public and private subnets
- **Security Groups** with appropriate access rules
- **IAM Roles** and policies for secure resource access

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                           VPC                               │
│  ┌─────────────────┐                 ┌─────────────────┐    │
│  │ Public Subnet   │                 │ Private Subnet  │    │
│  │                 │                 │                 │    │
│  │  ┌──────────┐   │                 │                 │    │
│  │  │    EC2   │   │                 │   (Future RDS)  │    │
│  │  │ Instance │   │                 │                 │    │
│  │  └──────────┘   │                 │                 │    │
│  └─────────────────┘                 └─────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                    │
                    ▼
         ┌─────────────────┐         ┌─────────────────┐
         │   S3 Bucket     │         │ Secrets Manager │
         │   (Encrypted)   │         │   (Encrypted)   │
         └─────────────────┘         └─────────────────┘
```

## Features

### **Security & Secrets Management:**
- **Automated Password Generation**: EC2 password is automatically generated using `random_password`
- **AWS Secrets Manager Integration**: All sensitive data is stored securely:
  - EC2 instance credentials (username/password)
  - S3 bucket information
  - Application configuration secrets
  - Database credentials (placeholder for future use)
- **IAM Roles**: Least-privilege access with specific permissions for Secrets Manager and S3

### **Infrastructure Components:**
1. **VPC**: Custom VPC with DNS support
2. **Subnets**: Public and private subnets across multiple AZs
3. **Internet Gateway**: For public internet access
4. **Security Groups**: 
   - EC2: SSH (22), HTTP (80), HTTPS (443), Custom (8080)
   - RDS: MySQL (3306), PostgreSQL (5432) - for future use
   - ALB: HTTP/HTTPS - for future load balancing
5. **EC2 Instance**: Configurable with Amazon Linux 2 or Ubuntu
6. **S3 Bucket**: Encrypted with lifecycle policies and versioning
7. **Secrets Manager**: Multiple secrets for different use cases

### **Automation & Configuration:**
- **User Data Script**: Automatically installs and configures:
  - AWS CLI v2
  - Docker
  - Node.js (LTS)
  - Python 3 with boto3
  - Sample scripts for AWS integration
- **IAM Integration**: Instance can access Secrets Manager and S3 without hardcoded credentials
- **Unique Naming**: Random suffix ensures globally unique resource names

## Prerequisites

1. **AWS CLI** installed and configured with appropriate credentials
2. **Terraform** >= 1.0 installed
3. **AWS Account** with sufficient permissions to create:
   - VPC, EC2, S3, Secrets Manager, IAM resources
4. **Key Pair**: An existing EC2 key pair in your AWS region for SSH access

## Quick Start

### 1. Prepare Your Environment

```bash
# Clone or navigate to the template directory
cd <path-to>/templates/terraform/aws-vm-secrets

# Verify AWS CLI configuration
aws sts get-caller-identity

# Create a key pair if you don't have one
aws ec2 create-key-pair --key-name my-terraform-keypair --query 'KeyMaterial' --output text > my-terraform-keypair.pem
chmod 400 my-terraform-keypair.pem  # On Linux/macOS
```

### 2. Configure Variables

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your specific values
notepad terraform.tfvars  # On Windows
# nano terraform.tfvars   # On Linux/macOS
```

**Important**: Update these values in `terraform.tfvars`:
- `key_pair_name`: Name of your existing EC2 key pair
- `aws_region`: Your preferred AWS region
- `s3_bucket_name_prefix`: Unique prefix for your S3 bucket
- Other values as needed

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the configuration
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### 4. Access Your Infrastructure

After deployment, Terraform will output important information:

```bash
# Get EC2 public IP
terraform output ec2_public_ip

# Get S3 bucket name
terraform output s3_bucket_name
```

## Accessing Secrets

### Via AWS CLI
```bash
# List all secrets
aws secretsmanager list-secrets --region us-east-1

# Get EC2 credentials
aws secretsmanager get-secret-value --secret-id terraform-demo-ec2-credentials-<suffix> --region us-east-1

# Get S3 bucket info
aws secretsmanager get-secret-value --secret-id terraform-demo-s3-bucket-info-<suffix> --region us-east-1
```

### Via Python (boto3)
```python
import boto3
import json

def get_secret(secret_name, region_name="us-east-1"):
    client = boto3.client('secretsmanager', region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])

# Get EC2 credentials
ec2_creds = get_secret('terraform-demo-ec2-credentials-<suffix>')
print(f"Username: {ec2_creds['username']}")
print(f"Password: {ec2_creds['password']}")
```

## Connecting to Your EC2 Instance

### SSH Access
```bash
# Get the public IP from Terraform output
PUBLIC_IP=$(terraform output -raw ec2_public_ip)

# Connect via SSH (replace with your key pair path)
ssh -i /path/to/your-keypair.pem ec2-user@$PUBLIC_IP
```

### Test AWS Integration
Once connected to your EC2 instance:

```bash
# Test AWS CLI access
/opt/myapp/test_aws.sh

# Test Python integration with Secrets Manager
python3 /opt/myapp/get_secrets.py

# Test S3 access
aws s3 ls s3://your-bucket-name/
```

## Module Structure

```
modules/
├── vpc/                    # VPC, subnets, routing
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── security_groups/        # Security groups for EC2, RDS, ALB
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── secrets_manager/        # AWS Secrets Manager resources
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── s3/                     # S3 bucket with security configurations
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── ec2/                    # EC2 instance with IAM roles
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── user_data.sh        # Instance initialization script
```

## Customization

### Change EC2 Instance Type
Edit `terraform.tfvars`:
```hcl
ec2_instance_type = "t3.small"  # or t3.medium, t3.large, etc.
```

### Use Ubuntu Instead of Amazon Linux
Edit `modules/ec2/variables.tf`:
```hcl
variable "use_ubuntu" {
  default = true
}
```

### Add Custom Security Group Rules
Edit `modules/security_groups/main.tf` to add additional ingress/egress rules.

### Modify S3 Lifecycle Policies
Edit `modules/s3/main.tf` to customize lifecycle rules, storage classes, and retention periods.

### Add Additional Secrets
Edit `modules/secrets_manager/main.tf` to create additional secrets for your application needs.

## Advanced Configuration

### Environment-Specific Deployments
Create separate `.tfvars` files for different environments:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

### Enable S3 Static Website Hosting
Add to `modules/s3/main.tf`:
```hcl
resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

### Add RDS Database
Extend the template by adding an RDS module and using the existing RDS security group.

## Security Best Practices

✅ **Implemented Security Features:**
- All secrets stored in AWS Secrets Manager (encrypted at rest)
- EC2 instance uses IAM roles (no hardcoded credentials)
- S3 bucket has public access blocked
- S3 bucket encryption enabled (AES-256)
- VPC with private subnets for sensitive resources
- Security groups with least-privilege access
- EBS volumes encrypted

✅ **Additional Recommendations:**
- Use AWS Systems Manager Session Manager instead of SSH for enhanced security
- Enable CloudTrail for audit logging
- Set up AWS Config for compliance monitoring
- Use AWS WAF if exposing web applications
- Implement resource tagging strategy for cost allocation

## Monitoring and Maintenance

### View Logs
```bash
# EC2 user data logs
ssh -i your-key.pem ec2-user@$PUBLIC_IP
sudo tail -f /var/log/cloud-init-output.log
```

### Backup Strategy
- **S3**: Versioning enabled, lifecycle policies configured
- **Secrets**: Automatic backups with 7-day retention
- **EC2**: Consider enabling EBS snapshots

### Cost Optimization
- EC2 instances default to `t3.micro` (eligible for free tier)
- S3 lifecycle policies transition to cheaper storage classes
- Secrets Manager has minimal costs for small-scale usage

## Troubleshooting

### Common Issues

**1. Key Pair Not Found**
```
Error: InvalidKeyPair.NotFound
```
**Solution**: Ensure the key pair exists in your AWS region:
```bash
aws ec2 describe-key-pairs --region us-east-1
```

**2. S3 Bucket Name Already Exists**
```
Error: BucketAlreadyExists
```
**Solution**: Change the `s3_bucket_name_prefix` in your `terraform.tfvars` file.

**3. Insufficient Permissions**
```
Error: Access Denied
```
**Solution**: Ensure your AWS credentials have the required permissions. Required policies:
- `AmazonEC2FullAccess`
- `AmazonS3FullAccess` 
- `SecretsManagerReadWrite`
- `IAMFullAccess`
- `AmazonVPCFullAccess`

**4. Region Mismatch**
Ensure all your resources are in the same region specified in `terraform.tfvars`.

### Debug Mode
Enable detailed logging:
```bash
export TF_LOG=DEBUG
terraform apply
```

## Clean Up

To destroy all resources:

```bash
# Destroy infrastructure
terraform destroy

# Confirm by typing 'yes' when prompted
```

**Warning**: This will permanently delete all resources created by this template, including data in S3 buckets and secrets in Secrets Manager.

## Outputs

After successful deployment, you'll see outputs including:

| Output | Description |
|--------|-------------|
| `vpc_id` | VPC identifier |
| `ec2_instance_id` | EC2 instance identifier |
| `ec2_public_ip` | Public IP address of EC2 instance |
| `ec2_private_ip` | Private IP address of EC2 instance |
| `s3_bucket_name` | Name of the created S3 bucket |
| `s3_bucket_arn` | ARN of the S3 bucket |
| `secrets_manager_ec2_secret_arn` | ARN of EC2 credentials secret |
| `secrets_manager_s3_secret_arn` | ARN of S3 bucket info secret |

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review AWS CloudTrail logs for API call details
3. Use `terraform plan` to preview changes before applying
4. Consult the [Terraform AWS Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## License

This template is provided as-is for educational and development purposes. Please review and customize according to your organization's security and compliance requirements.
