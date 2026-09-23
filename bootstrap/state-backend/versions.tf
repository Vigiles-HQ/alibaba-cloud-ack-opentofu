terraform {
  required_version = ">= 1.6.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.241.0, < 2.0.0"
    }
  }

  # First apply uses the local backend. Migrate into this bucket only after the bucket and lock table exist.
  backend "oss" {}
}
