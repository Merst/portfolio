terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0b4624933067d393a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.tf_ec2_key.key_name
  tags = {
    Name = "PortfolioServer"
  }


}
