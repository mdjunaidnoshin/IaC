# Data block to fetch default VPC and availability zones
data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Get the first available default subnet in the default VPC
data "aws_subnet" "default" {
  availability_zone = data.aws_availability_zones.available.names[0]
  default_for_az    = true
  vpc_id            = data.aws_vpc.default.id
}

resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
  associate_public_ip_address = false
  user_data = base64encode(var.user_data_script)
  subnet_id = coalesce(var.subnet_id, data.aws_subnet.default.id)

}