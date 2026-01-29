variable "location" {
  description = "Azure region"
  type        = string
  default     = "polandcentral"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = "frogtech-rg"
}

variable "my_ip" {
  description = "my_public_ip"
  type        = string
}
