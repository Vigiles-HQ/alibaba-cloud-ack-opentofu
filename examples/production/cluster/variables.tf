variable "region" {
  type        = string
  description = "Alibaba Cloud region for this stack."
  default     = "ap-southeast-1"
}

variable "state_bucket" {
  type        = string
  description = "OSS bucket created by the state-backend stack."
}

variable "state_region" {
  type        = string
  description = "Region of the OSS state bucket."
  default     = "ap-southeast-1"
}

variable "tablestore_endpoint" {
  type        = string
  description = "TableStore endpoint for the state lock. Replace the example host."
}

variable "tablestore_table" {
  type        = string
  description = "Lock table created by the state-backend module."
  default     = "opentofu_lock"
}

variable "kubernetes_version" {
  type        = string
  description = "Value from DescribeKubernetesVersionMetadata for ap-southeast-1."
}

variable "key_name" {
  type        = string
  description = "Existing ECS key pair name."
}

variable "secret_encryption_key_id" {
  type        = string
  description = "User-created CMK for Kubernetes Secret encryption."
}

variable "disk_kms_key_id" {
  type        = string
  description = "User-created CMK for ECS system disks. Not alias/acs/ecs."
}

variable "system_instance_types" {
  type        = map(list(string))
  description = "Acceptable system-node types per zone suffix a, b and c. Query stock before apply."
}

variable "application_instance_types" {
  type        = list(string)
  description = "Spot candidate types. Stock is per zone and per billing method."
}

variable "compensate_with_on_demand" {
  type        = bool
  description = "Requires multi_az_policy COST_OPTIMIZED. Leave false when zone balance matters more than filling capacity."
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
