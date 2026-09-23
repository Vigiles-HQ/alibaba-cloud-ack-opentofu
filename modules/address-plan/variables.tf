variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR. Check it against current routes before apply."

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && split("/", var.vpc_cidr)[1] == "16"
    error_message = "This example plan expects a /16 VPC."
  }
}

variable "zones" {
  type        = list(string)
  description = "Zones the address plan divides the VPC across."

  validation {
    condition     = length(var.zones) == 3 && length(distinct(var.zones)) == 3
    error_message = "Provide three distinct zone IDs."
  }
}

variable "name_prefix" {
  type        = string
  description = "Prefix for vSwitch names, such as example or nonprod."
}
