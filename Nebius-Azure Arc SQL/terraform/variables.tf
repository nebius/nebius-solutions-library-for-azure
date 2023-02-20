# CLoudIL variables
variable "il_folder_id" {
  description = "CloudIL folder id"
  type        = string
}

variable "il_cloud_id" {
  description = "CloudIL cloud id"
  type        = string
}

variable "il_zone" {
  description = "CloudIL region"
  type        = string
  default     = "il1-a"
}

variable "il_provider_key_file" {
  description = "CloudIL provider key file for authentication"
  default = "./key.json"

  # See documentation in the link below on how to create key.json service account file
  # https://cloudil.co.il/docs/cli/operations/authentication/service-account
}

variable "il_token" {
  description = "CloudIL authentication token"
  default = null
  
  # See documentation in the link below on how to obtain Oauth token for authentication
  # https://cloudil.co.il/docs/cli/operations/authentication/user
}

variable "vm_admin_user" {
  description = "SQL VM Administrator Username"
  type        = string
  default     = "Administrator"
}

variable "vm_admin_password" {
  description = "SQL VM Administrator Password"
  type        = string
}

variable "vm_name" {
  description = "SQL VM Name"
  type        = string
  default     = "sql-arc-vm"
}

# Azure variables
variable "az_location" {
  description = "Azure Region"
  type        = string
  default     = "westeurope"
}

variable "az_resource_group_name" {
  description = "Azure resource group"
  type        = string
  default     = "azure-arc-demo"
}

variable "az_arc_sql_name" {
  description = "Azure Arc SQL name"
  type        = string
  default     = "azure-arc-sql"
}

variable "az_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "az_service_principal_app_id" {
  description = "Azure service principal App ID"
  type        = string
}

variable "az_service_principal_secret" {
  description = "Azure service principal App Password"
  type        = string
}

variable "az_service_principal_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}