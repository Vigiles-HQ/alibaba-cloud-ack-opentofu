output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  value = module.vpc.cidr_block
}

output "service_cidr" {
  value = module.plan.service_cidr
}

output "route_table_ids" {
  value = module.vpc.route_table_ids
}

output "subnet_ids_by_role" {
  value = module.subnets.ids_by_role
}

output "subnet_ids_by_name" {
  value = module.subnets.ids_by_name
}

output "subnets" {
  value = module.plan.subnets
}
