# *********************** Web server(s) *****************************
resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0b4624933067d393a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.tf_ec2_key.key_name
  tags = {
    Name = "PortfolioServer"
  }
}

# *************** Web server Security Group *************************
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Security Group for the public subnet."
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "ec2SecGroup"
  }
}

# TCP port 22 for SSH (restrict this in production)
resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.ec2_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# TCP port 80 for HTTP
resource "aws_vpc_security_group_ingress_rule" "http_ec2_ingress" {
  security_group_id = aws_security_group.ec2_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# TCP port 443 for HTTPS
resource "aws_vpc_security_group_ingress_rule" "https_ec2_ingress" {
  security_group_id = aws_security_group.ec2_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

# Outbound HTTP/HTTPS to anywhere
resource "aws_vpc_security_group_egress_rule" "gen_ec2_egress" {
  security_group_id = aws_security_group.ec2_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}
