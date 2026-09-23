output "cluster_id" {
  value = alicloud_cs_managed_kubernetes.this.id
}

output "cluster_name" {
  value = alicloud_cs_managed_kubernetes.this.name
}

output "rrsa_metadata" {
  description = "OIDC issuer details used when you bind a RAM role to a service account. RRSA does not replace Kubernetes RBAC."
  value       = alicloud_cs_managed_kubernetes.this.rrsa_metadata
}

output "slb_intranet" {
  description = "Private API SLB identifier. An empty internet SLB is the expected result."
  value       = alicloud_cs_managed_kubernetes.this.slb_intranet
}

output "security_group_id" {
  description = "Enterprise security group ACK creates for node ENIs."
  value       = alicloud_cs_managed_kubernetes.this.security_group_id
}

output "required_service_roles" {
  description = "Roles that must already exist. AdministratorAccess on the caller does not create them."
  value       = local.required_service_roles
}
