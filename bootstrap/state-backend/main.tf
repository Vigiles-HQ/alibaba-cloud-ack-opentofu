module "backend" {
  source              = "../../modules/state-backend"
  bucket_name         = var.bucket_name
  table_instance_name = "example-tf-locks"
  resource_group_id   = var.state_resource_group_id
  tags                = var.tags
}
