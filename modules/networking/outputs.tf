output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
}

output "flask_app_sg_id" {
  value = aws_security_group.flask_app_sg.id
}

output "flask_db_sg_id" {
  value = aws_security_group.flask_db_sg.id
}
