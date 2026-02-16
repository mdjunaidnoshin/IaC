output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

output "security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_instance.id
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.my_instance.private_ip
}

output "iam_role_name" {
  description = "The name of the IAM role for SSM access"
  value       = aws_iam_role.ec2_ssm_role.name
}

output "ssm_session_command" {
  description = "Command to initiate SSM Session Manager connection to the instance"
  value       = "aws ssm start-session --target ${aws_instance.my_instance.id} --region ap-south-1"
}
