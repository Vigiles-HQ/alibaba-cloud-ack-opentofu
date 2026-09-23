output "ids_by_role" {
  description = "vSwitch IDs grouped by role."
  value = {
    for role in distinct([for subnet in values(var.subnets) : subnet.role]) :
    role => [
      for name, subnet in var.subnets : alicloud_vswitch.this[name].id
      if subnet.role == role
    ]
  }
}

output "ids_by_name" {
  value = { for name, subnet in alicloud_vswitch.this : name => subnet.id }
}

output "zone_by_name" {
  value = { for name, subnet in var.subnets : name => subnet.zone_id }
}
