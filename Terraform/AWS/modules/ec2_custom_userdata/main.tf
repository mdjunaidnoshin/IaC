# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-subnet"
    }
  )
}

# Security Group for EC2 in Private Subnet
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instance in private subnet"
  vpc_id      = aws_vpc.main.id

  # Outbound: Allow all traffic to external resources
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-sg"
    }
  )
}

# IAM Role for SSM Access
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-ssm-role"
    }
  )
}

# Attach SSM access policy to the role
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# EC2 Instance in Private Subnet
resource "aws_instance" "my_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = base64encode(var.user_data_script)

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-jenkins-instance"
    }
  )

  depends_on = [
    aws_iam_instance_profile.ec2_profile
  ]
}