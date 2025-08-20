variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "terraform-demo-vpc"
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
  default = [
    {
      name          = "terraform-demo-subnet"
      ip_cidr_range = "10.0.1.0/24"
      region        = "us-central1"
    }
  ]
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    name          = string
    direction     = string
    priority      = number
    source_ranges = list(string)
    target_tags   = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
  default = [
    {
      name          = "allow-ssh"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["ssh"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    },
    {
      name          = "allow-http"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["http-server"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
    },
    {
      name          = "allow-https"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["https-server"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
    }
  ]
}

variable "vm_instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
  default     = "terraform-demo-instance"
}

variable "vm_machine_type" {
  description = "Machine type for the Compute Engine instance"
  type        = string
  default     = "e2-micro"
}

variable "vm_username" {
  description = "Username for the VM instance"
  type        = string
  default     = "terraform-user"
}

variable "bucket_name_prefix" {
  description = "Prefix for Cloud Storage bucket name"
  type        = string
  default     = "terraform-demo-bucket"
}

variable "keyring_name" {
  description = "Name of the KMS keyring"
  type        = string
  default     = "terraform-demo-keyring"
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "development"
    project     = "terraform-gcp-demo"
    managed_by  = "terraform"
    owner       = "devops-team"
  }
}
