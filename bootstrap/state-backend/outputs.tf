output "bucket" {
  value = module.backend.bucket
}

output "lock_instance" {
  value = module.backend.lock_instance
}

output "lock_table" {
  value = module.backend.lock_table
}
