# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "pjpfe"
}

variable "root_name" {
  type    = string
  default = "PJPFE ES"
}

variable "deploy_core_landing_zones" {
  type    = bool
  default = true
}
variable "deploy_connectivity_resources" {
  type    = bool
  default = true
}

variable "connectivity_resources_location" {
  type    = string
  default = "northeurope"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_connectivity_resources_custom"
  }
}
variable "deploy_management_resources" {
  type    = bool
  default = true
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "security_alerts_email_address" {
  type    = string
  default = "paulj@johnst.co.uk" # Replace this value with your own email address.
}

variable "management_resources_location" {
  type    = string
  default = "NorthEurope"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_management_resources_custom"
  }
}