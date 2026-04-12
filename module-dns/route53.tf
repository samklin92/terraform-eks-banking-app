resource "aws_route53_zone" "r53_zone" {
  name    = var.domain_name
  comment = "Managed by Terraform - banking app ${var.environment}"

  force_destroy = false

  tags = {
    Name        = "${var.environment}-hosted-zone"
    Environment = var.environment
  }
}

resource "aws_route53_record" "bank_frontend" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_hostname]
}

resource "aws_route53_record" "bank_api" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_hostname]
}
