locals {
  # Third-octet indexes inside the /16. /20 indexes are the cidrsubnet netnum for a 4-bit extension.
  zone_layout = [
    { edge = 0, management = 1, data = 2, node = 1, pod = 2 },
    { edge = 48, management = 49, data = 50, node = 4, pod = 5 },
    { edge = 96, management = 97, data = 98, node = 7, pod = 8 },
  ]

  subnets = merge([
    for index, zone_id in var.zones : {
      "${var.name_prefix}-edge-${regex("[a-z0-9]$", zone_id)}" = {
        zone_id = zone_id
        role    = "edge"
        cidr    = cidrsubnet(var.vpc_cidr, 8, local.zone_layout[index].edge)
      }
      "${var.name_prefix}-mgmt-${regex("[a-z0-9]$", zone_id)}" = {
        zone_id = zone_id
        role    = "management"
        cidr    = cidrsubnet(var.vpc_cidr, 8, local.zone_layout[index].management)
      }
      "${var.name_prefix}-data-${regex("[a-z0-9]$", zone_id)}" = {
        zone_id = zone_id
        role    = "data"
        cidr    = cidrsubnet(var.vpc_cidr, 8, local.zone_layout[index].data)
      }
      "${var.name_prefix}-node-${regex("[a-z0-9]$", zone_id)}" = {
        zone_id = zone_id
        role    = "node"
        cidr    = cidrsubnet(var.vpc_cidr, 4, local.zone_layout[index].node)
      }
      "${var.name_prefix}-pod-${regex("[a-z0-9]$", zone_id)}" = {
        zone_id = zone_id
        role    = "pod"
        cidr    = cidrsubnet(var.vpc_cidr, 4, local.zone_layout[index].pod)
      }
    }
  ]...)
}
