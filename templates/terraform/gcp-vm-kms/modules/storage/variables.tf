variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for storage resources"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Prefix for Cloud Storage bucket name"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for bucket encryption"
  type        = string
}

variable "folder_names" {
  description = "List of folder names to create in the bucket"
  type        = list(string)
  default     = ["uploads", "logs", "backups", "temp"]
}

variable "compute_service_account_email" {
  description = "Service account email for Compute Engine instances"
  type        = string
  default     = ""
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name for bucket notifications"
  type        = string
  default     = ""
}

variable "common_labels" {
  description = "Common labels to apply to all storage resources"
  type        = map(string)
  default     = {}
}
