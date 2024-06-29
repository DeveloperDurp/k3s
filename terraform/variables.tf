locals {
  config = merge(local.env_config["default"], lookup(local.env_config, var.environment, {}))
}

variable "pm_api_url" {
  description = "API URL to Proxmox provider"
  type        = string
}

variable "pm_password" {
  description = "Passowrd to Proxmox provider"
  type        = string
}

variable "pm_user" {
  description = "UIsername to Proxmox provider"
  type        = string
  default     = "root@pam"
}

variable "environment" {
  description = "environment of the deployment"
  type        = string
  default     = "dev"
}
