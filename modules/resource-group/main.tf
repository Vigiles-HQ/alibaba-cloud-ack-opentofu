resource "alicloud_resource_manager_resource_group" "this" {
  display_name        = var.display_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
