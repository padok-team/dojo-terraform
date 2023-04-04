module "acm" {
  source = "git@github.com:padok-team/terraform-aws-acm?ref=v0.1.0"

  domain_name          = "*.${var.context.dns.domain_name}"
  zone_id              = module.dns_zone.this.zone_id
  validate_certificate = true
}
