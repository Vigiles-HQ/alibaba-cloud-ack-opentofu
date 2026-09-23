locals {
  # DNAT is intentionally absent. Inbound application traffic uses a separate ALB or WAF design.
  snat_only = true
}
