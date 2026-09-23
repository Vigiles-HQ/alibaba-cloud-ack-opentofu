variable "name" {
  type        = string
  description = "Short lowercase identifier for this resource."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,40}$", var.name))
    error_message = "name must be a short lowercase identifier."
  }
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR. Example production value is 172.21.0.0/16. Confirm it does not overlap existing VPCs, VPN, CEN or office ranges before apply."

  validation {
    condition     = can(cidrhost(var.cidr_block, 0)) && tonumber(split("/", var.cidr_block)[1]) <= 16
    error_message = "cidr_block must be a valid CIDR of /16 or larger."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID. Supply it from the resource-groups stack."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."

  validation {
    condition = alltrue([
      for key in ["project", "environment", "owner", "managed-by"] : contains(keys(var.tags), key)
    ])
    error_message = "tags must include project, environment, owner and managed-by."
  }
}

variable "route_roles" {
  type        = set(string)
  description = "Route tables created for each address role. NAT default routes are attached later, and only to node and pod."
  default     = ["edge", "management", "data", "node", "pod"]
}
