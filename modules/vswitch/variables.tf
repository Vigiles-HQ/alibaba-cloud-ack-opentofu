variable "vpc_id" {
  type        = string
  description = "Existing VPC ID."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR. Check it against current routes before apply."

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR."
  }
}

variable "service_cidr" {
  type        = string
  description = "Kubernetes ClusterIP range. It must sit outside the VPC. Example: 172.30.10.0/24."

  validation {
    condition     = can(cidrhost(var.service_cidr, 0))
    error_message = "service_cidr must be a valid CIDR."
  }
}

variable "subnets" {
  description = "Map of vSwitch name to zone, role and CIDR. Roles: edge, management, data, node, pod."
  type = map(object({
    zone_id = string
    role    = string
    cidr    = string
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) : contains(["edge", "management", "data", "node", "pod"], subnet.role)
    ])
    error_message = "Each subnet role must be edge, management, data, node or pod."
  }

  validation {
    condition     = length(var.subnets) == length(distinct([for subnet in values(var.subnets) : subnet.cidr]))
    error_message = "Subnet CIDRs must be unique."
  }
}

variable "route_table_ids" {
  type        = map(string)
  description = "Route table ID keyed by role."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
}
