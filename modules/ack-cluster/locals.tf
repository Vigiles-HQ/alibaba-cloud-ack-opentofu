locals {
  required_service_roles = [
    "AliyunCSDefaultRole",
    "AliyunCSManagedKubernetesRole",
    "AliyunCSManagedSecurityRole",
    "AliyunCSKubernetesAuditRole",
    "AliyunCSManagedLogRole",
    "AliyunCSManagedCmsRole",
    "AliyunCSManagedCsiRole",
    "AliyunCSManagedNetworkRole",
    "AliyunCSManagedArmsRole",
  ]

  service_overlaps_vpc = (
    cidrcontains(var.vpc_cidr, cidrhost(var.service_cidr, 0)) ||
    cidrcontains(var.service_cidr, cidrhost(var.vpc_cidr, 0))
  )
}
