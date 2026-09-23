variable "chart_version" {
  type        = string
  description = "Reviewed argo-cd chart version."
}

variable "cluster_api_host" {
  type        = string
  description = "Private API address. Do not commit a kubeconfig file."
}

variable "cluster_ca_certificate" {
  type        = string
  sensitive   = true
  description = "Cluster CA bytes supplied by the CI secret store at runtime."
}

variable "cluster_token" {
  type        = string
  sensitive   = true
  description = "Short-lived token. Do not write it into backend.hcl or this file's defaults."
}
