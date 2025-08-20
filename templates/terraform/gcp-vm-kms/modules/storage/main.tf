# Cloud Storage bucket with unique naming
resource "google_storage_bucket" "main" {
  project  = var.project_id
  name     = "${var.bucket_name_prefix}-${var.random_suffix}"
  location = var.region

  # Versioning
  versioning {
    enabled = true
  }

  # Encryption
  encryption {
    default_kms_key_name = var.kms_key_id
  }

  # Lifecycle management
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  # Access control
  uniform_bucket_level_access = true

  # Public access prevention
  public_access_prevention = "enforced"

  # Labels
  labels = var.common_labels
}

# Create sample folders/objects
resource "google_storage_bucket_object" "folders" {
  for_each = toset(var.folder_names)
  
  bucket = google_storage_bucket.main.name
  name   = "${each.value}/"
  content = " "  # Empty content to create folder
}
