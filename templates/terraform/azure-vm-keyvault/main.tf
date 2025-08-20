terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Random password for VM admin
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Resource Group Module
module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Network Module
module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  subnet_name         = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
  tags                = var.tags
}

# Key Vault Module (deployed before VM to store credentials)
module "key_vault" {
  source              = "./modules/key_vault"
  resource_group_name = module.resource_group.name
  location            = var.location
  key_vault_name      = var.key_vault_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = var.tags
}

# Store VM credentials in Key Vault
resource "azurerm_key_vault_secret" "vm_admin_username" {
  name         = "vm-admin-username"
  value        = var.vm_admin_username
  key_vault_id = module.key_vault.id
  depends_on   = [module.key_vault]
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  value        = random_password.vm_password.result
  key_vault_id = module.key_vault.id
  depends_on   = [module.key_vault]
}

# Storage Account Module
module "storage_account" {
  source              = "./modules/storage_account"
  resource_group_name = module.resource_group.name
  location            = var.location
  storage_account_name = var.storage_account_name
  tags                = var.tags
}

# Store Storage Account key in Key Vault
resource "azurerm_key_vault_secret" "storage_account_key" {
  name         = "storage-account-primary-key"
  value        = module.storage_account.primary_access_key
  key_vault_id = module.key_vault.id
  depends_on   = [module.key_vault, module.storage_account]
}

# Virtual Machine Module
module "virtual_machine" {
  source              = "./modules/virtual_machine"
  resource_group_name = module.resource_group.name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  subnet_id           = module.network.subnet_id
  admin_username      = var.vm_admin_username
  admin_password      = random_password.vm_password.result
  tags                = var.tags
}
