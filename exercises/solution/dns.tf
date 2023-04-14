data "aws_route53_zone" "this" {
  name = local.zone_name
}

data "aws_lb" "dojo" {
  name = "padok-dojo-lb"
}

resource "aws_route53_record" "these" {
  for_each = local.applications
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = "${local.github_handle}-${each.key}.${local.zone_name}"
  type     = "CNAME"
  ttl      = "60"
  records  = [data.aws_lb.this.dns_name]
}
