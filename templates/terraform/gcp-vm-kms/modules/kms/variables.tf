variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for KMS resources"
  type        = string
}

variable "keyring_name" {
  description = "Name of the KMS keyring"
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

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "common_labels" {
  description = "Common labels to apply to all KMS resources"
  type        = map(string)
  default     = {}
}
