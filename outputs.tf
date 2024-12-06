output "instance_id" {
  description = "ID of the EC2 instnace"
  value = aws_instance.app_server_test123.id
}

output "instnace_public_ip" {
  description = "Public IP address of the EC2 instnace"
  value = aws_instance.app_server_test123.public_ip
}