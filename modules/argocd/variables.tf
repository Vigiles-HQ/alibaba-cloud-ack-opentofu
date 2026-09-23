variable "chart_version" {
  type        = string
  description = "argo-cd Helm chart version you have reviewed. Do not leave this floating."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.chart_version))
    error_message = "chart_version must be an exact x.y.z chart version."
  }
}

variable "ha" {
  type        = bool
  description = "True for production. False keeps a single replica set for non-production."
}

variable "namespace" {
  type        = string
  description = "Namespace for the Argo CD release."
  default     = "argocd"
}
