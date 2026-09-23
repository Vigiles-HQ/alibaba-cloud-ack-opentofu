locals {
  # Capacity with no reserved throughput is PayAsYouGo. HighPerformance is unnecessary for rare lock writes.
  instance_type = "Capacity"
}
