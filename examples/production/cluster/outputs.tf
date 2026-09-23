output "cluster_id" {
  value = module.cluster.cluster_id
}

output "private_api_slb" {
  value = module.cluster.slb_intranet
}

output "system_pool_ids" {
  value = {
    a = module.system_a.node_pool_id
    b = module.system_b.node_pool_id
    c = module.system_c.node_pool_id
  }
}

output "application_pool_id" {
  value = module.application.node_pool_id
}

output "log_project" {
  value = module.logging.project_name
}
