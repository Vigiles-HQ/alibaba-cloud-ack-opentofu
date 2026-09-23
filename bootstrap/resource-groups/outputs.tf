output "example_prod_id" {
  value = module.group["example_prod"].id
}

output "example_nonprod_id" {
  value = module.group["example_nonprod"].id
}

output "network_id" {
  value = module.group["network"].id
}

output "security_id" {
  value = module.group["security"].id
}

output "observability_id" {
  value = module.group["observability"].id
}

output "state_id" {
  value = module.group["state"].id
}
