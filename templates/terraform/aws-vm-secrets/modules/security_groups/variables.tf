variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all security group resources"
  type        = map(string)
  default     = {}
}
