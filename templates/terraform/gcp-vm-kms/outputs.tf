output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "vpc_network_self_link" {
  description = "Self link of the VPC network"
  value       = module.vpc.network_self_link
}

output "subnet_self_links" {
  description = "Self links of the subnets"
  value       = module.vpc.subnet_self_links
}

output "vm_instance_id" {
  description = "ID of the Compute Engine instance"
  value       = module.compute_engine.instance_id
}

output "vm_external_ip" {
  description = "External IP address of the Compute Engine instance"
  value       = module.compute_engine.external_ip
}

output "vm_internal_ip" {
  description = "Internal IP address of the Compute Engine instance"
  value       = module.compute_engine.internal_ip
}

output "storage_bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = module.storage.bucket_name
}

output "storage_bucket_url" {
  description = "URL of the Cloud Storage bucket"
  value       = module.storage.bucket_url
}

output "kms_keyring_id" {
  description = "ID of the KMS keyring"
  value       = module.kms.keyring_id
}

output "kms_vm_key_id" {
  description = "ID of the VM credentials KMS key"
  value       = module.kms.vm_key_id
}

output "kms_storage_key_id" {
  description = "ID of the storage KMS key"
  value       = module.kms.storage_key_id
}

# Sensitive outputs
output "vm_username" {
  description = "VM username (stored in KMS)"
  value       = var.vm_username
  sensitive   = true
}

output "random_suffix" {
  description = "Random suffix used for unique naming"
  value       = random_string.suffix.result
}
