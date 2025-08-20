output "name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Secondary access key for the storage account"
  value       = azurerm_storage_account.main.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint for the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
