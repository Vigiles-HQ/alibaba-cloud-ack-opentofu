variable "display_name" {
  type        = string
  description = "Name shown in Resource Management. A resource group organises billing and RAM conditions. It does not create a network boundary."

  validation {
    condition     = length(var.display_name) >= 1 && length(var.display_name) <= 50
    error_message = "display_name must be 1 to 50 characters."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Stable identifier for the resource group."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,62}$", var.resource_group_name))
    error_message = "resource_group_name must start with a letter and contain only lowercase letters, digits and hyphens."
  }
}

variable "tags" {
  type        = map(string)
  description = "Cost and ownership tags. Tags do not grant or deny API access by themselves."

  validation {
    condition = alltrue([
      for key in ["project", "environment", "owner", "managed-by"] : contains(keys(var.tags), key)
    ])
    error_message = "tags must include project, environment, owner and managed-by."
  }
}
