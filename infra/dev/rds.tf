variable "db_password" {
  description = "The password for the RDS instance."
  type        = string
  sensitive   = true
}

# ************************ Database section *************************

resource "aws_db_instance" "portfolio_database" {
  identifier              = "portfolio_db"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  engine                  = "postgres"
  engine_version          = "16.5"
  username                = "postgres"
  password                = var.db_password
  backup_retention_period = 7
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  
  tags = {
    Name        = "MyPostgresRDS"
    Environment = "Development"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Security group to allow access to the RDS instance
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Allow RDS access to our EC2 instance."

  tags = {
    Name = "RDS_Security_Group"
  }
}

# TCP port 443 for HTTPS
resource "aws_vpc_security_group_ingress_rule" "ec2_rds_ingress" {
  security_group_id = aws_security_group.rds_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432
  referenced_security_group_id = aws_security_group.ec2_security_group.id
}

# Outbound HTTP/HTTPS to anywhere
resource "aws_vpc_security_group_egress_rule" "gen_rds_egress" {
  security_group_id = aws_security_group.rds_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}
