variable "secret_name_prefix" {
  description = "Prefix for secret names"
  type        = string
}

variable "ec2_username" {
  description = "Username for EC2 instance"
  type        = string
}

variable "ec2_password" {
  description = "Password for EC2 instance"
  type        = string
  sensitive   = true
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all secrets"
  type        = map(string)
  default     = {}
}
