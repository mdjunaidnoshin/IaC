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
  description = "The subnet ID where the EC2 instance will be placed. If not provided, uses the first default VPC subnet"
  default     = null
}
