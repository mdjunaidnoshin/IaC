resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
  associate_public_ip_address = false
  user_data = base64encode(var.user_data_script)

}