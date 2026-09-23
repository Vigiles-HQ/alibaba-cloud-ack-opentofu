variable "project_name" {
  type        = string
  description = "SLS project name for control plane logs."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,60}$", var.project_name))
    error_message = "project_name must be a lowercase SLS project name."
  }
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID."
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID. Supply it from the resource-groups stack."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
}
