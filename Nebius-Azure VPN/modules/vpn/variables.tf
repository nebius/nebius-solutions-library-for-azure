#-------------------------------
# Common Variables
#-------------------------------
variable "public_key_path" {
  description = "Path to public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "labels" {
  description = "A set of key/value label pairs to assign."
  type        = map(string)
  default     = {
    "environment"        = "test"
    "service" = "vpn"
  }
}

#-------------------------------
# CloudIL Variables
#-------------------------------
variable "il_folder_id" {
  description = "CloudIL folder id"
  type        = string
}

variable "il_cloud_id" {
  description = "CloudIL cloud id"
  type        = string
}

variable "zone" {
  description = "CloudIL default Zone for provisoned resources"
  default     = "il1-a"
}


variable "cloudil_vpc_id" {
  description = "ID of the CloudIL VPC where VPN instance will be created"
}

variable "cloudil_subnet_range" {
  description = "Describe list of subnets that you wish to connect to the VPN from the CloudIL side"
  default = "192.168.0.0/24"
}

variable "il_provider_key_file" {
  description = "CloudIL provider key file for authentication"
  default = "./key.json"
}

#-------------------------------
# Azure Variables
#-------------------------------

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

variable "location" {
  description = "azure location to create resources in"
}
variable "rgname" {
  description = "azure resource-group name to create the gateway"
}

variable "azure_vnet_name" {
  description = "name of the azure VNET where VPN gateway will be attached and GateWay subnet will be created"
}


variable "azure_subnet_range" {
  description = "Describe list of subnets that you wish to connect to the VPN from the Azure side"
  default = ["10.151.0.0/24"]
}

variable "azure_gateway_subnet_range" {
  description = "Describe subnet for vpn gateway in azure"
  default = ["10.0.255.0/24"]
}

