output "acm_certificate_arn" {
  description = "The ACM certificate arn for wildcard TLS."
  value       = module.acm.this.acm_certificate_arn
}

output "this" {
  description = "Route 53 DNS Zone."
  value = {
    domain_name = var.context.dns.domain_name # TODO: Find another solution (output a variable is an antipattern)
    zone_id     = module.dns_zone.this.zone_id
  }
}
