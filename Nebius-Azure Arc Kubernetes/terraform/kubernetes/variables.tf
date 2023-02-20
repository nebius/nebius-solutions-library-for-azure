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
  default     = "ru-central1-a"
}

variable "il_k8s_version" {
  description = "CloudIL Kubernetes version"
  default     = "1.21"
}

variable "il_k8s_channel" {
  description = "CloudIL Kubernetes update channel"
  default     = "RAPID"
}

variable "il_k8s_cidr" {
  description = "CloudIL Kubernetes cluster CIDR"
  type        = list(string)
  default     = ["192.168.101.0/24"]
}