resource "aws_route53_record" "these" {
  for_each = toset(var.context.vm.github_usernames)

  zone_id = var.context.dns.zone_id
  name    = "${each.value}.${var.context.dns.domain_name}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.this[each.value].public_ip]
}
