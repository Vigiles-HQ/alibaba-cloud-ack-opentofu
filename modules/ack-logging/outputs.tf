output "project_name" {
  value = alicloud_log_project.this.project_name
}

output "flow_logstore" {
  value = alicloud_log_store.flow.logstore_name
}

output "audit_logstore" {
  value = alicloud_log_store.audit.logstore_name
}
