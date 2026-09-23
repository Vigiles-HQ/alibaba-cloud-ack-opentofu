terraform {
  required_version = ">= 1.6.0"

  # Point init at backend/*.hcl.example after the bucket and lock table exist.
  backend "oss" {}
}
