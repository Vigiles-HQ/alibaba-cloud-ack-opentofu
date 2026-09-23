resource "alicloud_cs_kubernetes_node_pool" "this" {
  cluster_id     = var.cluster_id
  node_pool_name = var.name
  vswitch_ids    = var.vswitch_ids
  instance_types = var.instance_types
  key_name       = var.key_name
  image_type     = "AliyunLinux3"

  instance_charge_type = local.system_mode ? "PrePaid" : "PostPaid"
  period               = local.system_mode ? 1 : null
  period_unit          = local.system_mode ? "Month" : null
  auto_renew           = local.system_mode ? var.auto_renew : null
  auto_renew_period    = local.system_mode ? 1 : null
  desired_size         = local.system_mode ? var.desired_size : null

  spot_strategy             = local.application_mode ? "SpotAsPriceGo" : "NoSpot"
  spot_instance_remedy      = local.application_mode
  compensate_with_on_demand = local.application_mode ? var.compensate_with_on_demand : false
  multi_az_policy           = var.multi_az_policy

  system_disk_category          = "cloud_essd"
  system_disk_size              = 120
  system_disk_performance_level = "PL0"
  system_disk_encrypted         = true
  system_disk_kms_key           = var.disk_kms_key_id
  system_disk_encrypt_algorithm = "aes-256"

  # ECS treats 0 as "do not assign a public IP". Confirm the provider schema before apply.
  internet_max_bandwidth_out = 0
  install_cloud_monitor      = true
  resource_group_id          = var.resource_group_id
  tags                       = var.tags

  dynamic "scaling_config" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      min_size = var.min_size
      max_size = var.max_size
    }
  }

  dynamic "labels" {
    for_each = var.labels
    content {
      key   = labels.key
      value = labels.value
    }
  }

  dynamic "taints" {
    for_each = var.taints
    content {
      key    = taints.value.key
      value  = taints.value.value
      effect = taints.value.effect
    }
  }

  lifecycle {
    precondition {
      condition     = local.application_mode || (var.desired_size == 1 && length(var.vswitch_ids) == 1 && !var.enable_autoscaling)
      error_message = "A system pool is one subscription node in one zone, with autoscaling off."
    }

    precondition {
      condition     = local.system_mode || (var.enable_autoscaling && length(var.vswitch_ids) >= 3 && var.min_size >= 1 && var.max_size > var.min_size)
      error_message = "An application pool needs three zone vSwitches and an autoscaling maximum above the minimum."
    }

    precondition {
      condition     = !var.compensate_with_on_demand || var.multi_az_policy == "COST_OPTIMIZED"
      error_message = "compensate_with_on_demand is honoured only when multi_az_policy is COST_OPTIMIZED. BALANCE will not fall back to on-demand."
    }

    precondition {
      condition     = local.application_mode || length([for taint in var.taints : taint if taint.effect == "NoSchedule"]) > 0
      error_message = "System pools need a NoSchedule taint so application pods stay on the Spot pool."
    }
  }
}
