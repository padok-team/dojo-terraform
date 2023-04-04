data "aws_route53_zone" "root_zone" {
  name         = var.context.dns.root_zone_name
  private_zone = false

  provider = aws.root
}

resource "aws_route53_record" "delegation" {
  zone_id  = data.aws_route53_zone.root_zone.zone_id
  name     = var.context.dns.domain_name
  type     = "NS"
  ttl      = 60
  records  = module.dns_zone.this.name_servers
  provider = aws.root
}

module "dns_zone" {
  source = "git@github.com:padok-team/terraform-aws-route53-zone.git?ref=v0.2.0"

  name = var.context.dns.domain_name

  declare_ns_records = false
  root_zone_id       = data.aws_route53_zone.root_zone.zone_id
}
