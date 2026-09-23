variable "region" {
  type        = string
  description = "Alibaba Cloud region for this stack."
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "Example production VPC. Reject it if it overlaps any current route."
  default     = "172.21.0.0/16"
}

variable "zones" {
  type        = list(string)
  description = "Zones the address plan divides the VPC across."
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "network_resource_group_id" {
  type        = string
  description = "ID from the resource-groups stack. Example shape: rg-example."
}

variable "allow_example_cidrs" {
  type        = bool
  description = "Set true only after the example CIDRs are confirmed unique in this account."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
  default = {
    project     = "example"
    environment = "production"
    owner       = "platform"
    managed-by  = "opentofu"
  }
}
