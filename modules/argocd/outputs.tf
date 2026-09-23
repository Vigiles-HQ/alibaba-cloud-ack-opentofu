output "namespace" {
  value = var.namespace
}

output "service_name" {
  description = "ClusterIP service. It is reachable only from networks that can already reach the cluster."
  value       = "argocd-server"
}

output "ha" {
  value = var.ha
}
