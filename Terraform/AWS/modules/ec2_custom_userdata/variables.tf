variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet where EC2 will be deployed"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone for the subnet"
  default     = "ap-south-1a"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0848881f2a3dcebd1" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
}

variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance"
  default = "t4g.medium"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the EC2 instance"
  default     = {
    Name = "JenkinsServer"
  }
}

variable "user_data_script" {
  type        = string
  description = "User data script to install and configure Jenkins on Ubuntu"
  default     = <<-EOF
              #!/bin/bash
              set -e
              
              # Update system packages
              apt-get update
              apt-get upgrade -y
              
              # Install Java (Jenkins requires Java)
              apt-get install -y fontconfig openjdk-17-jre-headless
              
              # Add Jenkins repository
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              
              # Update package manager with Jenkins repo
              apt-get update
              
              # Install Jenkins
              apt-get install -y jenkins
              
              # Enable Jenkins to start on boot
              systemctl enable jenkins
              
              # Start Jenkins service
              systemctl start jenkins
              
              # Log initial admin password
              echo "Jenkins initial admin password will be available in /var/lib/jenkins/secrets/initialAdminPassword"
              EOF
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID where the EC2 instance will be placed. If not provided, uses the module's private subnet"
  default     = null
}
