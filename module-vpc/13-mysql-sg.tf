resource "aws_security_group" "mysql_sg" {
  name        = "${var.environment}-mysql-sg"
  description = "Security group for MySQL RDS - banking app"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description = "MySQL from VPC private subnets only"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrblock]
  }

  egress {
    description = "Allow outbound to VPC only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidrblock]
  }

  tags = {
    Name        = "${var.environment}-mysql-sg"
    Environment = var.environment
  }
}
