locals {
  groups = {
    example_prod = {
      display_name        = "example-prod"
      resource_group_name = "example-prod"
      environment         = "production"
    }
    example_nonprod = {
      display_name        = "example-nonprod"
      resource_group_name = "example-nonprod"
      environment         = "nonproduction"
    }
    network = {
      display_name        = "network-shared"
      resource_group_name = "network-shared"
      environment         = "shared"
    }
    security = {
      display_name        = "security-shared"
      resource_group_name = "security-shared"
      environment         = "shared"
    }
    observability = {
      display_name        = "observability-shared"
      resource_group_name = "observability-shared"
      environment         = "shared"
    }
    state = {
      display_name        = "platform-state"
      resource_group_name = "platform-state"
      environment         = "shared"
    }
  }
}
