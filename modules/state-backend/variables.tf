variable "bucket_name" {
  type        = string
  description = "Globally unique OSS bucket name for state. Example prefix only. Do not reuse a name from another account."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,62}$", var.bucket_name))
    error_message = "bucket_name must be a valid OSS bucket name."
  }
}

variable "table_instance_name" {
  type        = string
  description = "TableStore instance that holds the lock table."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.table_instance_name))
    error_message = "table_instance_name must be a lowercase TableStore instance name."
  }
}

variable "lock_table_name" {
  type        = string
  description = "TableStore table used as the OpenTofu lock."
  default     = "opentofu_lock"
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID. Supply it from the resource-groups stack."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
}
