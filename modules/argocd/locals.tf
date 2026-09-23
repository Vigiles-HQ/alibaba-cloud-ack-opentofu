locals {
  server_replicas = var.ha ? 2 : 1
  repo_replicas   = var.ha ? 2 : 1
}
