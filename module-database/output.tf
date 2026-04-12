output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql_db_instance.endpoint
  sensitive   = true
}

output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.mysql_db_instance.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.mysql_db_instance.arn
  sensitive   = true
}

output "rds_kms_key_arn" {
  description = "KMS key ARN used for RDS encryption"
  value       = aws_kms_key.rds_encryption_key.arn
  sensitive   = true
}
