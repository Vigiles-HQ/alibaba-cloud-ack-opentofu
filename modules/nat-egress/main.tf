resource "alicloud_nat_gateway" "this" {
  vpc_id               = var.vpc_id
  vswitch_id           = var.nat_vswitch_id
  nat_gateway_name     = var.name
  nat_type             = "Enhanced"
  payment_type         = "PayAsYouGo"
  internet_charge_type = "PayByLcu"
  description          = "Outbound SNAT for node and pod vSwitches. No DNAT."
  tags                 = var.tags
}

resource "alicloud_eip_address" "this" {
  address_name         = "${var.name}-eip"
  payment_type         = "PayAsYouGo"
  internet_charge_type = "PayByTraffic"
  bandwidth            = var.eip_bandwidth_mbps
  resource_group_id    = var.resource_group_id
  description          = "Shared SNAT address. Bandwidth is the cap for the EIP, not for each node."
  tags                 = var.tags
}

resource "alicloud_eip_association" "this" {
  allocation_id = alicloud_eip_address.this.id
  instance_id   = alicloud_nat_gateway.this.id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "this" {
  for_each          = var.snat_vswitch_ids
  snat_table_id     = alicloud_nat_gateway.this.snat_table_ids
  source_vswitch_id = each.value
  snat_ip           = alicloud_eip_address.this.ip_address

  depends_on = [alicloud_eip_association.this]
}

resource "alicloud_route_entry" "node" {
  route_table_id        = var.node_route_table_id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.this.id
}

resource "alicloud_route_entry" "pod" {
  route_table_id        = var.pod_route_table_id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.this.id
}
