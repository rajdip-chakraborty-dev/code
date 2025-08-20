variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the virtual machine"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  description = "Type of OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "vm_image" {
  description = "VM image configuration"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "tags" {
  description = "Tags to apply to VM resources"
  type        = map(string)
  default     = {}
}
