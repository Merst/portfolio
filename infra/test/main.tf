# Required extra information: AWS credentials. Login into your SSO,
# and click on "Access Keys", where you'll be able to set the new
# required environment variables.

# If you need to add a new Account to the SSO,
# Go in the management Account, then in IAM ID Center:
# Select the account within the organization, then grant access to
# the required role. The account should now appear in the SSO.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
}

# EC2 instance Security Group
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"
  
  # Allow SSH inbound for allowed IP addressess
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.security_group_ids
  }

  # TCP port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 443 for HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTP to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTPS to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create RSA key of size 4096 bits
resource "tls_private_key" "tf_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local file
resource "local_file" "tf_ec2_key" {
  content  = tls_private_key.tf_ec2_key.private_key_pem
  filename = "${path.module}/tf_ec2_key.pem"
}

# Create AWS key pair
resource "aws_key_pair" "tf_ec2_key" {
  key_name   = "tf_ec2_key"
  public_key = tls_private_key.tf_ec2_key.public_key_openssh
}

resource "aws_instance" "example" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.tf_ec2_key.key_name  # Name of the created Key Pair
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id] # Created SecGroup

}