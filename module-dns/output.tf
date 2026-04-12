output "route53_name_servers" {
  description = "Route53 hosted zone nameservers - paste these into Namecheap custom DNS"
  value       = aws_route53_zone.r53_zone.name_servers
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.r53_zone.zone_id
}

output "frontend_dns" {
  description = "Frontend DNS record"
  value       = aws_route53_record.bank_frontend.fqdn
}

output "api_dns" {
  description = "API DNS record"
  value       = aws_route53_record.bank_api.fqdn
}
