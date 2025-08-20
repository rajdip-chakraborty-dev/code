output "keyring_id" {
  description = "ID of the KMS keyring"
  value       = google_kms_key_ring.main.id
}

output "keyring_name" {
  description = "Name of the KMS keyring"
  value       = google_kms_key_ring.main.name
}

output "vm_key_id" {
  description = "ID of the VM credentials KMS key"
  value       = google_kms_crypto_key.vm_credentials.id
}

output "storage_key_id" {
  description = "ID of the storage encryption KMS key"
  value       = google_kms_crypto_key.storage.id
}

output "app_config_key_id" {
  description = "ID of the application config KMS key"
  value       = google_kms_crypto_key.app_config.id
}

output "database_key_id" {
  description = "ID of the database credentials KMS key"
  value       = google_kms_crypto_key.database.id
}

output "vm_credentials_ciphertext" {
  description = "Encrypted VM credentials"
  value       = google_kms_secret_ciphertext.vm_credentials.ciphertext
  sensitive   = true
}

output "database_credentials_ciphertext" {
  description = "Encrypted database credentials"
  value       = google_kms_secret_ciphertext.database_credentials.ciphertext
  sensitive   = true
}

output "app_config_ciphertext" {
  description = "Encrypted application configuration"
  value       = google_kms_secret_ciphertext.app_config.ciphertext
  sensitive   = true
}
