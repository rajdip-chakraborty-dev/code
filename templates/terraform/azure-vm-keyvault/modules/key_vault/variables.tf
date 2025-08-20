variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the key vault"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the key vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user/service principal that will have access to the key vault"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the key vault"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to key vault"
  type        = map(string)
  default     = {}
}
