variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the storage account"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "account_tier" {
  description = "Tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "containers" {
  description = "List of containers to create"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = [
    {
      name        = "data"
      access_type = "private"
    }
  ]
}

variable "tags" {
  description = "Tags to apply to storage account"
  type        = map(string)
  default     = {}
}
