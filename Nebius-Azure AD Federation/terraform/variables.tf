variable "il_auth" {
  description = "CloudIL service account key file or token"
  default     = "key.json" 
}

variable "il_folder_id" {
  description = "CloudIL folder-id"
  default     = "xxxxxx" # il config get folder-id
}

variable "il_cloud_id" {
  description = "CloudIL cloud-id"
  default     = "xxxxxx" # il config get cloud-id
}

variable "il_org_id" {
  description = "CloudIL organization-id"
  default     = "xxxxxx" # il organization-manager organization list
}

variable "az_tenant_id" {
  description = "Azure tenant ID"
  default     = "xxxxxx"
}

variable "app_name" {
  description = "Application name"
  default     = "az-il-federation"
}