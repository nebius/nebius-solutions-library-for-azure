terraform {


  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    template = {
      source = "hashicorp/template"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}


### Datasource
data "yandex_client_config" "client" {}






