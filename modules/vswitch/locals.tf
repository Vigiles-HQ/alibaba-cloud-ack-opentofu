locals {
  subnet_cidrs = [for subnet in values(var.subnets) : subnet.cidr]

  outside_vpc = [
    for cidr in local.subnet_cidrs : cidr
    if !cidrcontains(var.vpc_cidr, cidrhost(cidr, 0)) || !cidrcontains(var.vpc_cidr, cidrhost(cidr, -1))
  ]

  overlapping_pairs = [
    for pair in setproduct(local.subnet_cidrs, local.subnet_cidrs) : pair
    if pair[0] != pair[1] && (
      cidrcontains(pair[0], cidrhost(pair[1], 0)) || cidrcontains(pair[1], cidrhost(pair[0], 0))
    )
  ]

  service_overlaps_vpc = (
    cidrcontains(var.vpc_cidr, cidrhost(var.service_cidr, 0)) ||
    cidrcontains(var.service_cidr, cidrhost(var.vpc_cidr, 0))
  )
}
