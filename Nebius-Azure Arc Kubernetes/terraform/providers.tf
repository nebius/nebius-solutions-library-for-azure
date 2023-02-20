# Provider Configuration
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  
  service_account_key_file  = var.il_provider_key_file
  # token                     = var.il_token
  cloud_id                  = var.il_cloud_id
  folder_id                 = var.il_folder_id
  zone                      = var.il_zone
  endpoint                  = "api.cloudil.com:443"
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  client_id       = var.az_service_principal_app_id
  client_secret   = var.az_service_principal_secret
  tenant_id       = var.az_service_principal_tenant_id
  features {}
}