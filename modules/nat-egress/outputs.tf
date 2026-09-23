output "nat_gateway_id" {
  value = alicloud_nat_gateway.this.id
}

output "eip_address" {
  description = "SNAT source address. Use this value on a private Git allowlist. Do not publish it as a cluster endpoint."
  value       = alicloud_eip_address.this.ip_address
}

output "eip_id" {
  value = alicloud_eip_address.this.id
}
