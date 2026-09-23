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

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
  default = {
    project     = "example"
    environment = "nonproduction"
    owner       = "platform"
    managed-by  = "opentofu"
  }
}
