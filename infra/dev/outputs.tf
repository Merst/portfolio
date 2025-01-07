# *******************************************************************
# *************************** Outputs *******************************
# *******************************************************************

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_username" {
  value = aws_db_instance.postgres.username
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
