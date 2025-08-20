# Data source for latest Ubuntu LTS image
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# Data source for latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

# Service account for Compute Engine instance
resource "google_service_account" "compute_sa" {
  project      = var.project_id
  account_id   = "${var.instance_name}-sa"
  display_name = "Service Account for ${var.instance_name}"
  description  = "Service account for Compute Engine instance with KMS and Storage access"
}

# IAM binding for KMS access
resource "google_project_iam_member" "kms_crypto_key_encrypter_decrypter" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_service_account.compute_sa.email}"
}

# IAM binding for Storage access
resource "google_project_iam_member" "storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.compute_sa.email}"
}

# IAM binding for logging
resource "google_project_iam_member" "logging_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.compute_sa.email}"
}

# IAM binding for monitoring
resource "google_project_iam_member" "monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.compute_sa.email}"
}

# Startup script template
locals {
  startup_script = templatefile("${path.module}/startup_script.sh", {
    vm_username   = var.vm_username
    vm_password   = var.vm_password
    bucket_name   = var.bucket_name
    kms_key_id    = var.kms_key_id
    project_id    = var.project_id
  })
}

# Compute Engine instance
resource "google_compute_instance" "main" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  # Boot disk
  boot_disk {
    initialize_params {
      image = var.use_debian ? data.google_compute_image.debian.self_link : data.google_compute_image.ubuntu.self_link
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
    
    # Encrypt boot disk with KMS key
    kms_key_self_link = var.kms_key_id
  }

  # Network interface
  network_interface {
    subnetwork = var.subnet_self_link
    
    # Assign external IP
    access_config {
      // Ephemeral IP
    }
  }

  # Service account
  service_account {
    email  = google_service_account.compute_sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Metadata
  metadata = {
    enable-oslogin = "TRUE"
    startup-script = local.startup_script
  }

  # Network tags for firewall rules
  tags = var.network_tags

  # Labels
  labels = var.common_labels

  # Allow stopping for updates
  allow_stopping_for_update = true

  # Scheduling
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  depends_on = [
    google_service_account.compute_sa,
    google_project_iam_member.kms_crypto_key_encrypter_decrypter,
    google_project_iam_member.storage_object_admin
  ]
}
