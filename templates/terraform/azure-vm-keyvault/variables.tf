variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-terraform-demo"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-internal"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "saterraformdemo001"
}

variable "key_vault_name" {
  description = "Name of the key vault (must be globally unique)"
  type        = string
  default     = "kv-terraform-demo-001"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-terraform-demo"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "vm_admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Terraform-Demo"
    ManagedBy   = "Terraform"
  }
}
