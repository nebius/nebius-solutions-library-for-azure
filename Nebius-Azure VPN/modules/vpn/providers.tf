
provider "yandex" {
  # Please select either service_account_key_file option or token option
  # The details on obtaining the tokens is provided in the links below:
  # https://cloudil.co.il/docs/cli/operations/authentication/user
  # https://cloudil.co.il/docs/cli/operations/authentication/service-account
  
  service_account_key_file  = var.il_provider_key_file
  # token                     = var.il_token
  cloud_id                  = var.il_cloud_id
  folder_id                 = var.il_folder_id
  zone                      = var.zone
  endpoint                  = "api.cloudil.com:443"
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  client_id       = var.az_service_principal_app_id
  client_secret   = var.az_service_principal_secret
  tenant_id       = var.az_service_principal_tenant_id
  features {}
}