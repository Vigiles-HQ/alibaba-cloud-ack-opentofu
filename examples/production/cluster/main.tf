locals {
  remote_backend = {
    bucket              = var.state_bucket
    region              = var.state_region
    key                 = "terraform.tfstate"
    tablestore_endpoint = var.tablestore_endpoint
    tablestore_table    = var.tablestore_table
    encrypt             = true
    acl                 = "private"
  }
}

data "terraform_remote_state" "network" {
  backend = "oss"
  config = merge(local.remote_backend, {
    prefix = "platform-foundation/production-network"
  })
}

data "terraform_remote_state" "resource_groups" {
  backend = "oss"
  config = merge(local.remote_backend, {
    prefix = "platform-foundation/resource-groups"
  })
}

data "terraform_remote_state" "egress" {
  backend = "oss"
  config = merge(local.remote_backend, {
    prefix = "platform-foundation/production-egress"
  })
}

module "logging" {
  source            = "../../../modules/ack-logging"
  project_name      = "example-prod-ack"
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  resource_group_id = data.terraform_remote_state.resource_groups.outputs.observability_id
  tags              = var.tags
}

module "cluster" {
  source                    = "../../../modules/ack-cluster"
  name                      = "example-prod"
  kubernetes_version        = var.kubernetes_version
  vpc_cidr                  = data.terraform_remote_state.network.outputs.vpc_cidr
  service_cidr              = data.terraform_remote_state.network.outputs.service_cidr
  control_plane_vswitch_ids = data.terraform_remote_state.network.outputs.subnet_ids_by_role["management"]
  pod_vswitch_ids           = data.terraform_remote_state.network.outputs.subnet_ids_by_role["pod"]
  resource_group_id         = data.terraform_remote_state.resource_groups.outputs.example_prod_id
  secret_encryption_key_id  = var.secret_encryption_key_id
  sls_project_name          = module.logging.project_name
  tags                      = var.tags

  depends_on = [data.terraform_remote_state.egress]
}

module "system_a" {
  source            = "../../../modules/ack-node-pool"
  mode              = "system"
  name              = "system-a"
  cluster_id        = module.cluster.cluster_id
  vswitch_ids       = [data.terraform_remote_state.network.outputs.subnet_ids_by_name["example-node-a"]]
  instance_types    = var.system_instance_types["a"]
  key_name          = var.key_name
  disk_kms_key_id   = var.disk_kms_key_id
  resource_group_id = data.terraform_remote_state.resource_groups.outputs.example_prod_id
  desired_size      = 1
  labels            = { "node-role" = "system", "topology.kubernetes.io/zone" = "ap-southeast-1a" }
  taints = [{
    key    = "node-role"
    value  = "system"
    effect = "NoSchedule"
  }]
  tags = var.tags
}

module "system_b" {
  source            = "../../../modules/ack-node-pool"
  mode              = "system"
  name              = "system-b"
  cluster_id        = module.cluster.cluster_id
  vswitch_ids       = [data.terraform_remote_state.network.outputs.subnet_ids_by_name["example-node-b"]]
  instance_types    = var.system_instance_types["b"]
  key_name          = var.key_name
  disk_kms_key_id   = var.disk_kms_key_id
  resource_group_id = data.terraform_remote_state.resource_groups.outputs.example_prod_id
  desired_size      = 1
  labels            = { "node-role" = "system", "topology.kubernetes.io/zone" = "ap-southeast-1b" }
  taints = [{
    key    = "node-role"
    value  = "system"
    effect = "NoSchedule"
  }]
  tags = var.tags
}

module "system_c" {
  source            = "../../../modules/ack-node-pool"
  mode              = "system"
  name              = "system-c"
  cluster_id        = module.cluster.cluster_id
  vswitch_ids       = [data.terraform_remote_state.network.outputs.subnet_ids_by_name["example-node-c"]]
  instance_types    = var.system_instance_types["c"]
  key_name          = var.key_name
  disk_kms_key_id   = var.disk_kms_key_id
  resource_group_id = data.terraform_remote_state.resource_groups.outputs.example_prod_id
  desired_size      = 1
  labels            = { "node-role" = "system", "topology.kubernetes.io/zone" = "ap-southeast-1c" }
  taints = [{
    key    = "node-role"
    value  = "system"
    effect = "NoSchedule"
  }]
  tags = var.tags
}

module "application" {
  source                    = "../../../modules/ack-node-pool"
  mode                      = "application"
  name                      = "application-spot"
  cluster_id                = module.cluster.cluster_id
  vswitch_ids               = data.terraform_remote_state.network.outputs.subnet_ids_by_role["node"]
  instance_types            = var.application_instance_types
  key_name                  = var.key_name
  disk_kms_key_id           = var.disk_kms_key_id
  resource_group_id         = data.terraform_remote_state.resource_groups.outputs.example_prod_id
  enable_autoscaling        = true
  min_size                  = 2
  max_size                  = 10
  multi_az_policy           = var.compensate_with_on_demand ? "COST_OPTIMIZED" : "BALANCE"
  compensate_with_on_demand = var.compensate_with_on_demand
  labels                    = { "node-role" = "application" }
  tags                      = var.tags
}
