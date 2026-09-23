resource "alicloud_cs_managed_kubernetes" "this" {
  name         = var.name
  cluster_spec = "ack.pro.small"
  version      = var.kubernetes_version
  # Provider 1.293 derives the VPC from vswitch_ids and rejects an explicit vpc_id.
  vswitch_ids                  = var.control_plane_vswitch_ids
  pod_vswitch_ids              = var.pod_vswitch_ids
  service_cidr                 = var.service_cidr
  proxy_mode                   = "ipvs"
  ip_stack                     = "ipv4"
  resource_group_id            = var.resource_group_id
  new_nat_gateway              = false
  slb_internet_enabled         = false
  deletion_protection          = true
  enable_rrsa                  = true
  is_enterprise_security_group = true
  encryption_provider_key      = var.secret_encryption_key_id
  disable_encryption           = false
  control_plane_log_project    = var.sls_project_name
  control_plane_log_ttl        = "30"
  control_plane_log_components = ["apiserver", "kcm", "scheduler", "ccm", "controlplane-events"]
  tags                         = var.tags

  dynamic "addons" {
    for_each = var.addons
    content {
      name   = addons.value.name
      config = addons.value.config
    }
  }

  lifecycle {
    precondition {
      condition     = !local.service_overlaps_vpc
      error_message = "service_cidr overlaps the VPC. Choose a ClusterIP range outside ${var.vpc_cidr}."
    }

    precondition {
      condition     = length(setsubtract(var.control_plane_vswitch_ids, var.pod_vswitch_ids)) == length(var.control_plane_vswitch_ids)
      error_message = "pod_vswitch_ids must be different vSwitches from the control-plane vswitch_ids."
    }
  }
}
