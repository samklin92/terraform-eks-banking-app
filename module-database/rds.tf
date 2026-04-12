resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.environment}-mysql-subnet-group"
  subnet_ids = var.private_subnet_db_ids

  tags = {
    Name        = "${var.environment}-mysql-subnet-group"
    Environment = var.environment
    Tier        = "database"
  }
}

resource "aws_kms_key" "rds_encryption_key" {
  description             = "KMS key for RDS encryption - ${var.environment} banking app"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.environment}-rds-kms-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "rds_encryption_key_alias" {
  name          = "alias/${var.environment}-rds-key"
  target_key_id = aws_kms_key.rds_encryption_key.key_id
}

resource "aws_db_instance" "mysql_db_instance" {
  identifier        = "${var.environment}-mysql-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"

  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [var.aws_security_group_ids]

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name

  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_encryption_key.arn

  multi_az = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  deletion_protection     = true
  skip_final_snapshot     = false
  final_snapshot_identifier = "${var.environment}-mysql-final-snapshot"
  copy_tags_to_snapshot   = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery"
  ]

  tags = {
    Name        = "${var.environment}-mysql-db-instance"
    Environment = var.environment
    Tier        = "database"
    Encrypted   = "true"
  }

  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-rds-monitoring-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
