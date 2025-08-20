# Google Cloud Infrastructure with Terraform - Compute Engine, Cloud Storage, and KMS

This Terraform template deploys a complete Google Cloud Platform infrastructure including:
- **Compute Engine Instance** (Ubuntu 22.04 LTS or Debian 12)
- **Cloud Storage Bucket** with KMS encryption and lifecycle policies
- **Cloud KMS** for secure credential and data encryption
- **VPC Network** with custom subnets and firewall rules
- **Service Accounts** and IAM roles for secure resource access

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      VPC Network                            │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                 Custom Subnet                           ││
│  │                                                         ││
│  │  ┌──────────────────┐       ┌─────────────────────────┐ ││
│  │  │ Compute Engine   │       │    Service Account      │ ││
│  │  │   Instance       │◄──────┤  (KMS + Storage Access) │ ││
│  │  │ (Ubuntu/Debian)  │       └─────────────────────────┘ ││
│  │  └──────────────────┘                                   ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                    │                        │
                    ▼                        ▼
         ┌─────────────────────┐   ┌─────────────────────┐
         │  Cloud Storage      │   │    Cloud KMS        │
         │   (KMS Encrypted)   │   │   (Multi-Key Ring)  │
         │   • Versioning      │   │   • VM Credentials  │
         │   • Lifecycle Rules │   │   • Storage Keys    │
         │   • IAM Controls    │   │   • App Config      │
         └─────────────────────┘   └─────────────────────┘
```

## Features

### **Security & Secrets Management:**
- **Automated Password Generation**: VM password is automatically generated using `random_password`
- **Cloud KMS Integration**: All sensitive data is encrypted and stored securely:
  - VM instance credentials (username/password)
  - Application configuration secrets
  - Database credentials (placeholder for future use)
  - Storage encryption keys
- **Service Account**: Least-privilege access with specific permissions for KMS and Cloud Storage

### **Infrastructure Components:**
1. **VPC Network**: Custom VPC with configurable subnets
2. **Firewall Rules**: SSH (22), HTTP (80), HTTPS (443) access rules
3. **Cloud Router & NAT**: For secure internet access from private instances
4. **Compute Engine Instance**: Configurable with Ubuntu or Debian
5. **Cloud Storage Bucket**: KMS-encrypted with lifecycle policies and versioning
6. **Cloud KMS**: Multiple keys for different encryption purposes
7. **Service Accounts**: Dedicated service account with IAM roles

### **Automation & Configuration:**
- **Startup Script**: Automatically installs and configures:
  - Google Cloud SDK
  - Docker
  - Node.js (LTS)
  - Python 3 with Google Cloud client libraries
  - Sample scripts for GCP integration
- **IAM Integration**: Instance can access KMS and Cloud Storage without stored credentials
- **Unique Naming**: Random suffix ensures globally unique resource names

## Prerequisites

1. **Google Cloud SDK** installed and authenticated
2. **Terraform** >= 1.0 installed
3. **GCP Project** with the following APIs enabled:
   - Compute Engine API
   - Cloud Storage API
   - Cloud KMS API
   - Cloud Resource Manager API
   - IAM Service Account Credentials API
4. **Appropriate IAM permissions** to create and manage GCP resources

## Quick Start

### 1. Prepare Your Environment

```bash
# Clone or navigate to the template directory
cd <path-to>/templates/terraform/gcp-vm-kms

# Authenticate with Google Cloud
gcloud auth login
gcloud auth application-default login

# Set your project (replace with your actual project ID)
export GOOGLE_CLOUD_PROJECT="your-gcp-project-id"
gcloud config set project $GOOGLE_CLOUD_PROJECT

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iamcredentials.googleapis.com
```

### 2. Configure Variables

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your specific values
# On Windows:
notepad terraform.tfvars
# On Linux/macOS:
# nano terraform.tfvars
```

**Important**: Update these values in `terraform.tfvars`:
- `project_id`: Your GCP project ID
- `region` and `zone`: Your preferred GCP region and zone
- `bucket_name_prefix`: Unique prefix for your Cloud Storage bucket
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
# Get Compute Engine external IP
terraform output vm_external_ip

# Get Cloud Storage bucket name
terraform output storage_bucket_name

# Get KMS keyring information
terraform output kms_keyring_id
```

## Accessing Encrypted Secrets

### Via gcloud CLI
```bash
# List KMS keys
gcloud kms keys list --location=us-central1 --keyring=terraform-demo-keyring-<suffix>

# Decrypt a secret (example)
echo "encrypted_data_here" | base64 -d | gcloud kms decrypt \
  --key=vm-credentials-key \
  --keyring=terraform-demo-keyring-<suffix> \
  --location=us-central1 \
  --ciphertext-file=- \
  --plaintext-file=-
```

### Via Python (google-cloud-kms)
```python
from google.cloud import kms
import base64
import json

def decrypt_secret(project_id, location, key_ring, key_name, ciphertext):
    client = kms.KeyManagementServiceClient()
    key_name = client.crypto_key_path(project_id, location, key_ring, key_name)
    
    response = client.decrypt(request={
        "name": key_name, 
        "ciphertext": ciphertext
    })
    
    plaintext = response.plaintext.decode('utf-8')
    return json.loads(base64.b64decode(plaintext).decode('utf-8'))

# Usage
vm_creds = decrypt_secret(
    project_id="your-project",
    location="us-central1",
    key_ring="terraform-demo-keyring-suffix",
    key_name="vm-credentials-key",
    ciphertext=encrypted_data
)
print(f"Username: {vm_creds['username']}")
```

## Connecting to Your Compute Engine Instance

### SSH Access (with OS Login)
```bash
# Get the external IP from Terraform output
EXTERNAL_IP=$(terraform output -raw vm_external_ip)

# Connect via SSH using OS Login
gcloud compute ssh terraform-demo-instance --zone=us-central1-a

# Or use traditional SSH if you have configured keys
# ssh -i ~/.ssh/google_compute_engine username@$EXTERNAL_IP
```

### Test GCP Integration
Once connected to your Compute Engine instance:

```bash
# Test gcloud CLI access
/opt/myapp/test_gcp.sh

# Test Python integration with KMS
python3 /opt/myapp/decrypt_secrets.py

# Test Cloud Storage access
gsutil ls gs://your-bucket-name/
```

## Module Structure

```
modules/
├── vpc/                    # VPC network, subnets, firewall rules, NAT
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── kms/                    # Cloud KMS keyring and crypto keys
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── storage/                # Cloud Storage bucket with KMS encryption
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── compute_engine/         # Compute Engine instance with service account
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── startup_script.sh   # Instance initialization script
```

## Customization

### Change Compute Engine Machine Type
Edit `terraform.tfvars`:
```hcl
vm_machine_type = "e2-small"  # or e2-medium, n1-standard-1, etc.
```

### Use Debian Instead of Ubuntu
Edit `terraform.tfvars`:
```hcl
# Add this variable to use Debian
use_debian = true
```

### Add Custom Firewall Rules
Edit `terraform.tfvars` and add to the `firewall_rules` list:
```hcl
firewall_rules = [
  # ... existing rules ...
  {
    name          = "allow-custom-app"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["10.0.0.0/8"]
    target_tags   = ["app-server"]
    allow = [
      {
        protocol = "tcp"
        ports    = ["8080", "8443"]
      }
    ]
  }
]
```

### Modify Cloud Storage Lifecycle Policies
Edit `modules/storage/main.tf` to customize lifecycle rules and storage classes.

### Add Additional KMS Keys
Edit `modules/kms/main.tf` to create additional crypto keys for different purposes.

## Advanced Configuration

### Environment-Specific Deployments
Create separate `.tfvars` files for different environments:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

### Enable Cloud Storage Uniform Bucket-Level Access
The template already includes uniform bucket-level access by default.

### Add Cloud SQL Database
Extend the template by adding a Cloud SQL module and using KMS for database encryption.

### Configure Private Google Access
The template already includes private Google access for secure communication with Google APIs.

## Security Best Practices

✅ **Implemented Security Features:**
- All secrets encrypted with Cloud KMS
- Compute Engine instance uses service account (no stored credentials)
- Cloud Storage bucket has uniform bucket-level access
- Cloud Storage bucket encryption with customer-managed keys (CMEK)
- VPC with custom subnets and firewall rules
- Boot disk encryption with KMS keys
- OS Login enabled for secure SSH access

✅ **Additional Recommendations:**
- Use Identity-Aware Proxy (IAP) for secure access to instances
- Enable VPC Flow Logs for network monitoring
- Set up Cloud Security Command Center for security insights
- Use Binary Authorization for container security
- Implement organization policies for governance

## Monitoring and Maintenance

### View Logs
```bash
# Compute Engine startup script logs
gcloud compute ssh terraform-demo-instance --zone=us-central1-a
sudo tail -f /var/log/startup-script.log

# Cloud Logging
gcloud logging read "resource.type=gce_instance"
```

### Backup Strategy
- **Cloud Storage**: Versioning enabled, lifecycle policies configured
- **KMS Keys**: Automatic key rotation every 90 days
- **Compute Engine**: Consider scheduled snapshots

### Cost Optimization
- Compute Engine instances default to `e2-micro` (eligible for free tier)
- Cloud Storage lifecycle policies transition to cheaper storage classes
- KMS key operations have minimal costs for small-scale usage

## Troubleshooting

### Common Issues

**1. API Not Enabled**
```
Error: Error creating instance: googleapi: Error 403: Access Not Configured
```
**Solution**: Enable required APIs:
```bash
gcloud services enable compute.googleapis.com storage.googleapis.com cloudkms.googleapis.com
```

**2. Insufficient Permissions**
```
Error: Error creating KMS KeyRing: googleapi: Error 403: Permission denied
```
**Solution**: Ensure your account has the required roles:
- `Cloud KMS Admin`
- `Compute Admin`
- `Storage Admin`
- `Project IAM Admin`

**3. Quota Exceeded**
```
Error: Quota exceeded for quota metric 'compute.googleapis.com/cpus'
```
**Solution**: Request quota increase in the GCP Console or choose a smaller machine type.

**4. Project Billing Not Enabled**
```
Error: Cloud billing account not found or not enabled
```
**Solution**: Enable billing for your GCP project in the Console.

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

**Warning**: This will permanently delete all resources created by this template, including data in Cloud Storage buckets and KMS keys.

## Outputs

After successful deployment, you'll see outputs including:

| Output | Description |
|--------|-------------|
| `project_id` | GCP project identifier |
| `vm_instance_id` | Compute Engine instance identifier |
| `vm_external_ip` | External IP address of Compute Engine instance |
| `vm_internal_ip` | Internal IP address of Compute Engine instance |
| `storage_bucket_name` | Name of the created Cloud Storage bucket |
| `storage_bucket_url` | URL of the Cloud Storage bucket |
| `kms_keyring_id` | ID of the KMS keyring |
| `kms_vm_key_id` | ID of VM credentials KMS key |
| `kms_storage_key_id` | ID of storage encryption KMS key |

## Cost Estimation

**Estimated monthly costs (as of 2025):**
- Compute Engine e2-micro: ~$7-15/month (free tier eligible)
- Cloud Storage (50GB): ~$1-3/month
- Cloud KMS: ~$1/month (key versions + operations)
- VPC/Networking: Minimal for basic usage

**Total estimated cost**: ~$10-20/month for development workloads

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Google Cloud Logging for detailed error messages
3. Use `terraform plan` to preview changes before applying
4. Consult the [Terraform Google Provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
5. Review [Google Cloud documentation](https://cloud.google.com/docs)

## License

This template is provided as-is for educational and development purposes. Please review and customize according to your organization's security and compliance requirements.
