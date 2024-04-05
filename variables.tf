variable "resource_group_location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "vm-rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "ssh_key_name_prefix" {
  type        = string
  default     = "ssh"
  description = "Prefix of ssh key that will be generated"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "admin"
}

variable "base_script" {
  type        = string
  description = "The base script that will be executed on the VM."
  default     = "kube-install.sh"
}