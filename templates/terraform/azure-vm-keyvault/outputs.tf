output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.name
}

output "virtual_network_id" {
  description = "ID of the created virtual network"
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.network.subnet_id
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = module.storage_account.name
}

output "key_vault_id" {
  description = "ID of the created key vault"
  value       = module.key_vault.id
}

output "key_vault_uri" {
  description = "URI of the created key vault"
  value       = module.key_vault.vault_uri
}

output "vm_id" {
  description = "ID of the created virtual machine"
  value       = module.virtual_machine.vm_id
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = module.virtual_machine.public_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = module.virtual_machine.private_ip_address
}

# Sensitive outputs (will be masked in terraform output)
output "vm_admin_username" {
  description = "VM admin username (stored in Key Vault)"
  value       = var.vm_admin_username
  sensitive   = true
}

output "storage_account_primary_key" {
  description = "Primary access key for storage account (stored in Key Vault)"
  value       = module.storage_account.primary_access_key
  sensitive   = true
}
