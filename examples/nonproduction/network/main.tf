module "plan" {
  source      = "../../../modules/address-plan"
  vpc_cidr    = var.vpc_cidr
  zones       = var.zones
  name_prefix = "nonprod"
}

module "vpc" {
  source            = "../../../modules/vpc"
  name              = "example-nonprod"
  cidr_block        = var.vpc_cidr
  resource_group_id = var.network_resource_group_id
  tags              = var.tags
}

module "subnets" {
  source          = "../../../modules/vswitch"
  vpc_id          = module.vpc.id
  vpc_cidr        = var.vpc_cidr
  service_cidr    = module.plan.service_cidr
  subnets         = module.plan.subnets
  route_table_ids = module.vpc.route_table_ids
  tags            = var.tags
}

resource "terraform_data" "example_cidr_opt_in" {
  lifecycle {
    precondition {
      condition     = var.allow_example_cidrs
      error_message = "172.22.0.0/16 is an example. Set allow_example_cidrs after you prove it does not overlap VPCs, VPN, CEN or office ranges."
    }
  }
}
