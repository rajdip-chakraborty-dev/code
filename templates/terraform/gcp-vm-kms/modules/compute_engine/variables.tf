variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "zone" {
  description = "The GCP zone for the instance"
  type        = string
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the Compute Engine instance"
  type        = string
  default     = "e2-micro"
}

variable "subnet_self_link" {
  description = "Self link of the subnet where the instance will be deployed"
  type        = string
}

variable "vm_username" {
  description = "Username for the VM instance"
  type        = string
}

variable "vm_password" {
  description = "Password for the VM instance"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Name of the Cloud Storage bucket to grant access to"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for disk encryption"
  type        = string
}

variable "use_debian" {
  description = "Whether to use Debian image (true) or Ubuntu (false)"
  type        = bool
  default     = false
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of the boot disk"
  type        = string
  default     = "pd-standard"
}

variable "network_tags" {
  description = "Network tags for firewall rules"
  type        = list(string)
  default     = ["ssh", "http-server", "https-server"]
}

variable "common_labels" {
  description = "Common labels to apply to all Compute Engine resources"
  type        = map(string)
  default     = {}
}
