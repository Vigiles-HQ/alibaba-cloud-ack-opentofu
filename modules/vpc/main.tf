resource "alicloud_vpc" "this" {
  vpc_name          = var.name
  cidr_block        = var.cidr_block
  resource_group_id = var.resource_group_id
  description       = "ACK platform VPC. No CEN attachment and no peering in this module."
  tags              = var.tags
}

resource "alicloud_route_table" "role" {
  for_each         = var.route_roles
  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${var.name}-${each.key}"
  description      = "Routes for ${each.key} vSwitches. Internet default routes are added only for node and pod."
  tags             = merge(var.tags, { role = each.key })
}
