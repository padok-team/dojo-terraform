resource "aws_route53_record" "www" {
  zone_id = primary
  name    = "blblbly-app.dojo.padok.school"
  type    = "CNAME"
  ttl     = 300
  records = padok-dojo-lb
}