variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    name          = string
    direction     = string
    priority      = number
    source_ranges = list(string)
    target_tags   = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
}

variable "common_labels" {
  description = "Common labels to apply to all VPC resources"
  type        = map(string)
  default     = {}
}
