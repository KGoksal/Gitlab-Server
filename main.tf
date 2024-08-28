provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create a Subnet in the VPC
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"  # Availability zone in the region
}

# Create a Security Group
resource "aws_security_group" "gitlab_sg" {
  name        = "gitlab_sg"
  description = "Allow GitLab and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 Instance for GitLab
resource "aws_instance" "gitlab_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.gitlab_sg.id]
  subnet_id              = aws_subnet.main.id  # Ensure the instance is in the correct subnet

  user_data = file("${path.module}/user.sh")

  tags = {
    Name = "GitLab Server"
  }
}

# Outputs for Public IP and DNS
output "public_ip" {
  description = "Public IP of the GitLab server"
  value       = aws_instance.gitlab_server.public_ip
}

output "public_dns" {
  description = "Public DNS of the GitLab server"
  value       = aws_instance.gitlab_server.public_dns
}
