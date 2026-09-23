resource "alicloud_log_project" "this" {
  project_name      = var.project_name
  description       = "ACK control plane, audit and VPC flow logs. A project is not evidence that logs are arriving."
  resource_group_id = var.resource_group_id
  tags              = var.tags
}

resource "alicloud_log_store" "flow" {
  project_name     = alicloud_log_project.this.project_name
  logstore_name    = local.flow_logstore
  retention_period = 30
  shard_count      = 2
}

resource "alicloud_log_store_index" "flow" {
  project  = alicloud_log_store.flow.project_name
  logstore = alicloud_log_store.flow.logstore_name

  full_text {
    case_sensitive = false
    token          = ", '\";=()[]{}?@&<>/:\n\t"
  }
}

resource "alicloud_log_store" "audit" {
  project_name     = alicloud_log_project.this.project_name
  logstore_name    = local.audit_logstore
  retention_period = 90
  shard_count      = 2
}

resource "alicloud_log_store_index" "audit" {
  project  = alicloud_log_store.audit.project_name
  logstore = alicloud_log_store.audit.logstore_name

  full_text {
    case_sensitive = false
    token          = ", '\";=()[]{}?@&<>/:\n\t"
  }
}

resource "alicloud_vpc_flow_log" "this" {
  flow_log_name  = "${var.project_name}-vpc"
  resource_id    = var.vpc_id
  resource_type  = "VPC"
  traffic_type   = "All"
  project_name   = alicloud_log_project.this.project_name
  log_store_name = alicloud_log_store.flow.logstore_name
  description    = "VPC flow logs for the ACK VPC. Query them only after the index is active."
  status         = "Active"
}
