module "group" {
  for_each            = local.groups
  source              = "../../modules/resource-group"
  display_name        = each.value.display_name
  resource_group_name = each.value.resource_group_name
  tags = {
    project     = "example"
    environment = each.value.environment
    owner       = "platform"
    managed-by  = "opentofu"
  }
}
