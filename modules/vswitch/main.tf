resource "terraform_data" "cidr_guard" {
  input = {
    vpc_cidr     = var.vpc_cidr
    service_cidr = var.service_cidr
    subnets      = local.subnet_cidrs
  }

  lifecycle {
    precondition {
      condition     = length(local.outside_vpc) == 0
      error_message = "These vSwitch CIDRs are outside the VPC: ${join(", ", local.outside_vpc)}."
    }

    precondition {
      condition     = length(local.overlapping_pairs) == 0
      error_message = "vSwitch CIDRs overlap. Fix the address plan before apply."
    }

    precondition {
      condition     = !local.service_overlaps_vpc
      error_message = "service_cidr ${var.service_cidr} overlaps VPC ${var.vpc_cidr}. ClusterIP range must sit outside the VPC."
    }
  }
}

resource "alicloud_vswitch" "this" {
  for_each     = var.subnets
  vpc_id       = var.vpc_id
  zone_id      = each.value.zone_id
  cidr_block   = each.value.cidr
  vswitch_name = each.key
  tags         = merge(var.tags, { role = each.value.role, zone = each.value.zone_id })
  description  = "${each.value.role} vSwitch in ${each.value.zone_id}"

  depends_on = [terraform_data.cidr_guard]
}

resource "alicloud_route_table_attachment" "this" {
  for_each       = alicloud_vswitch.this
  vswitch_id     = each.value.id
  route_table_id = var.route_table_ids[var.subnets[each.key].role]
}
