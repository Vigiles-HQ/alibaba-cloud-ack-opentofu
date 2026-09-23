variable "name" {
  type        = string
  description = "Short lowercase identifier for this resource."
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID."
}

variable "nat_vswitch_id" {
  type        = string
  description = "vSwitch that hosts the NAT Gateway. Use an edge vSwitch, not a node or pod vSwitch."
}

variable "snat_vswitch_ids" {
  type        = map(string)
  description = "vSwitch IDs that may use SNAT. Pass node and pod vSwitches only."

  validation {
    condition     = length(var.snat_vswitch_ids) > 0
    error_message = "Provide the node and pod vSwitch IDs that need outbound SNAT."
  }
}

variable "node_route_table_id" {
  type        = string
  description = "Route table for node vSwitches. The NAT default route is attached here."
}

variable "pod_route_table_id" {
  type        = string
  description = "Route table for pod vSwitches. Keep pod egress on the NAT path."
}

variable "eip_bandwidth_mbps" {
  type        = number
  description = "Shared cap for all SNAT traffic on this EIP. It is not a per-node bandwidth guarantee."
  default     = 200

  validation {
    condition     = var.eip_bandwidth_mbps >= 1 && var.eip_bandwidth_mbps <= 200
    error_message = "eip_bandwidth_mbps must be between 1 and 200."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID. Supply it from the resource-groups stack."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
}
