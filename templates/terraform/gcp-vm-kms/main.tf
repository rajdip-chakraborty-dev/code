terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  default_labels = var.common_labels
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  default_labels = var.common_labels
}

# Generate random password for VM instance
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Generate random suffix for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_id     = var.project_id
  vpc_name       = var.vpc_name
  subnets        = var.subnets
  firewall_rules = var.firewall_rules
  
  common_labels = var.common_labels
}

# KMS Module (created first to store credentials)
module "kms" {
  source = "./modules/kms"
  
  project_id        = var.project_id
  region            = var.region
  keyring_name      = var.keyring_name
  vm_username       = var.vm_username
  vm_password       = random_password.vm_password.result
  random_suffix     = random_string.suffix.result
  
  common_labels = var.common_labels
}

# Cloud Storage Module
module "storage" {
  source = "./modules/storage"
  
  project_id         = var.project_id
  region             = var.region
  bucket_name_prefix = var.bucket_name_prefix
  random_suffix      = random_string.suffix.result
  kms_key_id         = module.kms.storage_key_id
  
  common_labels = var.common_labels
}

# Store GCS bucket name in KMS
resource "google_kms_secret_ciphertext" "gcs_bucket_info" {
  crypto_key = module.kms.app_config_key_id
  plaintext = base64encode(jsonencode({
    bucket_name = module.storage.bucket_name
    bucket_url  = module.storage.bucket_url
  }))
}

# Compute Engine Module
module "compute_engine" {
  source = "./modules/compute_engine"
  
  project_id         = var.project_id
  zone               = var.zone
  instance_name      = var.vm_instance_name
  machine_type       = var.vm_machine_type
  subnet_self_link   = module.vpc.subnet_self_links[0]
  vm_username        = var.vm_username
  vm_password        = random_password.vm_password.result
  bucket_name        = module.storage.bucket_name
  kms_key_id         = module.kms.vm_key_id
  
  common_labels = var.common_labels
  
  depends_on = [module.kms, module.storage]
}
