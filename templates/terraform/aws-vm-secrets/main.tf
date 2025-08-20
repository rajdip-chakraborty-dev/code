terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# Get current AWS account ID and caller identity
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Generate random password for EC2 instance
resource "random_password" "ec2_password" {
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
  
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  common_tags = var.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
  common_tags = var.common_tags
}

# Secrets Manager Module (created first to store credentials)
module "secrets_manager" {
  source = "./modules/secrets_manager"
  
  secret_name_prefix = var.secret_name_prefix
  ec2_username       = var.ec2_username
  ec2_password       = random_password.ec2_password.result
  random_suffix      = random_string.suffix.result
  
  common_tags = var.common_tags
}

# S3 Module
module "s3" {
  source = "./modules/s3"
  
  bucket_name_prefix = var.s3_bucket_name_prefix
  random_suffix      = random_string.suffix.result
  
  common_tags = var.common_tags
}

# Store S3 bucket name in Secrets Manager
resource "aws_secretsmanager_secret_version" "s3_bucket_name" {
  secret_id = module.secrets_manager.s3_bucket_secret_id
  secret_string = jsonencode({
    bucket_name = module.s3.bucket_name
    bucket_arn  = module.s3.bucket_arn
  })
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"
  
  instance_name        = var.ec2_instance_name
  instance_type        = var.ec2_instance_type
  key_pair_name        = var.key_pair_name
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_ids   = [module.security_groups.ec2_security_group_id]
  ec2_username         = var.ec2_username
  ec2_password         = random_password.ec2_password.result
  s3_bucket_name       = module.s3.bucket_name
  
  common_tags = var.common_tags
  
  depends_on = [module.secrets_manager, module.s3]
}
