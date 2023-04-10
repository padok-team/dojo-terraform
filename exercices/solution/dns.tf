locals {
  zone_name     = "dojo.padok.school"
  github_handle = "dummy-user"
  records       = ["frontend", "backend"]
}

data "aws_route53_zone" "this" {
  name         = local.zone_name
  private_zone = false # TODO: check if it's required to set this configuration
}

data "aws_elb" "this" {
  name = "" # TODO: Get ELB name in configuration
}

resource "aws_route53_record" "these" {
  for_each = toset(local.records)
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = "${local.github_handle}-${each.value}.${local.zone_name}"
  type     = "CNAME"
  ttl      = "60"
  records  = [data.aws_elb.this.dns_name]
}
