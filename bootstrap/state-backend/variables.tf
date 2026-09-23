variable "region" {
  type        = string
  description = "Region for the state bucket and TableStore instance."
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name you choose. Do not copy a name already in use."
}

variable "state_resource_group_id" {
  type        = string
  description = "Resource group for the state bucket. Comes from the resource-groups stack."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags for the state bucket and lock table."
  default = {
    project     = "example"
    environment = "shared"
    owner       = "platform"
    managed-by  = "opentofu"
  }
}
