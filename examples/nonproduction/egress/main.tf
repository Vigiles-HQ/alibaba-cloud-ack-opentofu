data "terraform_remote_state" "network" {
  backend = "oss"
  config = {
    bucket              = var.state_bucket
    region              = var.state_region
    prefix              = "platform-foundation/nonproduction-network"
    key                 = "terraform.tfstate"
    tablestore_endpoint = var.tablestore_endpoint
    tablestore_table    = var.tablestore_table
    encrypt             = true
    acl                 = "private"
  }
}

data "terraform_remote_state" "resource_groups" {
  backend = "oss"
  config = {
    bucket              = var.state_bucket
    region              = var.state_region
    prefix              = "platform-foundation/resource-groups"
    key                 = "terraform.tfstate"
    tablestore_endpoint = var.tablestore_endpoint
    tablestore_table    = var.tablestore_table
    encrypt             = true
    acl                 = "private"
  }
}

locals {
  subnets = data.terraform_remote_state.network.outputs.subnet_ids_by_name
  snat_vswitches = {
    for name, id in local.subnets : name => id
    if strcontains(name, "-node-") || strcontains(name, "-pod-")
  }
}

module "nat" {
  source              = "../../../modules/nat-egress"
  name                = "example-nonprod"
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  nat_vswitch_id      = local.subnets["nonprod-edge-a"]
  snat_vswitch_ids    = local.snat_vswitches
  node_route_table_id = data.terraform_remote_state.network.outputs.route_table_ids["node"]
  pod_route_table_id  = data.terraform_remote_state.network.outputs.route_table_ids["pod"]
  eip_bandwidth_mbps  = 200
  resource_group_id   = data.terraform_remote_state.resource_groups.outputs.network_id
  tags                = var.tags
}
