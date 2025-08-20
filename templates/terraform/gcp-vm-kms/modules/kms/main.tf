# KMS KeyRing
resource "google_kms_key_ring" "main" {
  project  = var.project_id
  name     = "${var.keyring_name}-${var.random_suffix}"
  location = var.region
}

# KMS Key for VM credentials
resource "google_kms_crypto_key" "vm_credentials" {
  name     = "vm-credentials-key"
  key_ring = google_kms_key_ring.main.id

  rotation_period = "7776000s" # 90 days

  labels = var.common_labels
}

# KMS Key for storage encryption
resource "google_kms_crypto_key" "storage" {
  name     = "storage-encryption-key"
  key_ring = google_kms_key_ring.main.id

  rotation_period = "7776000s" # 90 days

  labels = var.common_labels
}

# KMS Key for application configuration
resource "google_kms_crypto_key" "app_config" {
  name     = "app-config-key"
  key_ring = google_kms_key_ring.main.id

  rotation_period = "7776000s" # 90 days

  labels = var.common_labels
}

# KMS Key for database credentials (for future use)
resource "google_kms_crypto_key" "database" {
  name     = "database-credentials-key"
  key_ring = google_kms_key_ring.main.id

  rotation_period = "7776000s" # 90 days

  labels = var.common_labels
}

# Encrypt VM credentials
resource "google_kms_secret_ciphertext" "vm_credentials" {
  crypto_key = google_kms_crypto_key.vm_credentials.id
  plaintext = base64encode(jsonencode({
    username = var.vm_username
    password = var.vm_password
  }))
}

# Encrypt database credentials (placeholder)
resource "google_kms_secret_ciphertext" "database_credentials" {
  crypto_key = google_kms_crypto_key.database.id
  plaintext = base64encode(jsonencode({
    username = "dbadmin"
    password = "placeholder-password"
    host     = "placeholder-host"
    port     = 5432
    database = "myapp"
  }))
}

# Encrypt application configuration
resource "google_kms_secret_ciphertext" "app_config" {
  crypto_key = google_kms_crypto_key.app_config.id
  plaintext = base64encode(jsonencode({
    api_key    = "placeholder-api-key"
    jwt_secret = "placeholder-jwt-secret"
    env        = "development"
  }))
}
