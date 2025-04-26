output "web_security_group_id" {
  value = aws_security_group.web_server.id
}

output "database_security_group_id" {
  value = aws_security_group.database.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}