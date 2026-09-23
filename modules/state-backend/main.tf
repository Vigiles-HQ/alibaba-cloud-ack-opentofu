resource "alicloud_oss_bucket" "state" {
  bucket            = var.bucket_name
  storage_class     = "Standard"
  redundancy_type   = "ZRS"
  resource_group_id = var.resource_group_id
  tags              = var.tags

  # The bucket that will store this stack cannot be referenced as its own backend on the first apply.
  lifecycle {
    prevent_destroy = true
  }
}

resource "alicloud_oss_bucket_acl" "state" {
  bucket = alicloud_oss_bucket.state.bucket
  acl    = "private"
}

resource "alicloud_oss_bucket_public_access_block" "state" {
  bucket              = alicloud_oss_bucket.state.bucket
  block_public_access = true
}

resource "alicloud_oss_bucket_versioning" "state" {
  bucket = alicloud_oss_bucket.state.bucket
  status = "Enabled"
}

resource "alicloud_oss_bucket_server_side_encryption" "state" {
  bucket        = alicloud_oss_bucket.state.bucket
  sse_algorithm = "AES256"
}

resource "alicloud_ots_instance" "lock" {
  name          = var.table_instance_name
  description   = "OpenTofu state lock. Reserved capacity stays at zero."
  accessed_by   = "Any"
  instance_type = local.instance_type
  tags          = var.tags
}

resource "alicloud_ots_table" "lock" {
  instance_name = alicloud_ots_instance.lock.name
  table_name    = var.lock_table_name
  time_to_live  = -1
  max_version   = 1

  primary_key {
    name = "LockID"
    type = "String"
  }
}
