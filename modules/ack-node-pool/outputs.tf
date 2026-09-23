output "node_pool_id" {
  value = alicloud_cs_kubernetes_node_pool.this.id
}

output "node_pool_name" {
  value = alicloud_cs_kubernetes_node_pool.this.node_pool_name
}

output "scaling" {
  description = "Autoscaling bounds. A minimum does not force scale-down when pods cannot be evicted."
  value = {
    enabled = var.enable_autoscaling
    minimum = var.enable_autoscaling ? var.min_size : var.desired_size
    maximum = var.enable_autoscaling ? var.max_size : var.desired_size
  }
}
