output "id" {
  description = "Resource group ID to pass into network, cluster and logging stacks."
  value       = alicloud_resource_manager_resource_group.this.id
}

output "display_name" {
  value = alicloud_resource_manager_resource_group.this.display_name
}
