output "subnets" {
  description = "vSwitch plan keyed by name. Example only until you confirm the ranges against existing routes."
  value       = local.subnets
}

output "service_cidr" {
  description = "Example ClusterIP range outside 172.21.0.0/12. A /24 holds 254 services and cannot be changed later."
  value       = "172.30.10.0/24"
}
