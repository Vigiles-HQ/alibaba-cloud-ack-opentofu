output "bucket" {
  value = alicloud_oss_bucket.state.bucket
}

output "lock_instance" {
  value = alicloud_ots_instance.lock.name
}

output "lock_table" {
  value = alicloud_ots_table.lock.table_name
}

output "lock_instance_name" {
  description = "TableStore instance name. Build the endpoint from the instance name and region after you confirm it in the console."
  value       = alicloud_ots_instance.lock.name
}
