variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "folder_names" {
  description = "List of folder names to create in the bucket"
  type        = list(string)
  default     = ["uploads", "logs", "backups", "temp"]
}

variable "common_tags" {
  description = "Common tags to apply to all S3 resources"
  type        = map(string)
  default     = {}
}
