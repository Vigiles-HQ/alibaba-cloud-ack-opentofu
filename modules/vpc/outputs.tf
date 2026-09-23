output "id" {
  value = alicloud_vpc.this.id
}

output "cidr_block" {
  value = alicloud_vpc.this.cidr_block
}

output "route_table_ids" {
  description = "Route table ID keyed by role: edge, management, data, node, pod."
  value       = { for role, table in alicloud_route_table.role : role => table.id }
}
