provider "yandex" {
  #service_account_key_file  = var.il_auth
  token                     = var.il_auth
  cloud_id                  = var.il_cloud_id
  folder_id                 = var.il_folder_id
  endpoint                  = "api.cloudil.com:443"
}

provider "azuread" {
  tenant_id = var.az_tenant_id
  # Using Azure CLI authentication by default
}