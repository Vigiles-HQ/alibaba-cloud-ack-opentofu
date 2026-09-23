variable "mode" {
  type        = string
  description = "system: one subscription node, autoscaling off. application: multi-zone Spot pool."

  validation {
    condition     = contains(["system", "application"], var.mode)
    error_message = "mode must be system or application."
  }
}

variable "name" {
  type        = string
  description = "Short lowercase identifier for this resource."
}

variable "cluster_id" {
  type        = string
  description = "ACK cluster ID returned by the cluster module."
}

variable "vswitch_ids" {
  type        = list(string)
  description = "Node vSwitches. System pools pass one zone. The application pool passes three."
}

variable "instance_types" {
  type        = list(string)
  description = "Candidate ECS types for this zone or pool. Stock changes. There is no universal family."

  validation {
    condition = length(var.instance_types) > 0 && alltrue([
      for instance_type in var.instance_types : can(regex("^ecs\\.[a-z0-9]+\\.[a-z0-9]+$", instance_type))
    ])
    error_message = "instance_types must be ECS type names such as ecs.g7.xlarge, confirmed with DescribeAvailableResource."
  }
}

variable "key_name" {
  type        = string
  description = "Name of an existing ECS key pair. Do not pass private key material."

  validation {
    condition     = length(var.key_name) > 2 && !strcontains(var.key_name, "BEGIN")
    error_message = "key_name must be a key pair name, not a private key."
  }
}

variable "disk_kms_key_id" {
  type        = string
  description = "User-created CMK for the system disk. ECS will reject alias/acs/ecs when it is passed explicitly."

  validation {
    condition     = length(var.disk_kms_key_id) > 8 && !strcontains(var.disk_kms_key_id, "alias/acs/")
    error_message = "disk_kms_key_id must be a user-created CMK. Do not pass the ECS service key."
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

variable "desired_size" {
  type        = number
  description = "Node count. System pools must stay at 1."
  default     = 1
}

variable "enable_autoscaling" {
  type        = bool
  description = "Leave false on system pools. Application pools may enable it."
  default     = false
}

variable "min_size" {
  type        = number
  description = "Autoscaler floor. System pools do not autoscale."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Autoscaler ceiling. Must be greater than or equal to min_size."
  default     = 1
}

variable "multi_az_policy" {
  type        = string
  description = "ACK placement policy for a multi-zone application pool."
  default     = "BALANCE"

  validation {
    condition     = contains(["PRIORITY", "COST_OPTIMIZED", "BALANCE"], var.multi_az_policy)
    error_message = "multi_az_policy must be PRIORITY, COST_OPTIMIZED or BALANCE."
  }
}

variable "compensate_with_on_demand" {
  type        = bool
  description = "Create pay-as-you-go nodes when Spot cannot launch. The provider honours this only when multi_az_policy is COST_OPTIMIZED."
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Kubernetes labels applied to nodes in this pool."
  default     = {}
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = "Kubernetes taints. System pools use NoSchedule for node-role=system."
  default     = []
}

variable "auto_renew" {
  type        = bool
  description = "Renew subscription system nodes when the period ends."
  default     = true
}
