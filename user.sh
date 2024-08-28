#!/bin/bash

# Update and install docker packages
sudo yum update -y
sudo yum install -y docker

# Start Docker service
sudo service docker start
sudo usermod -aG docker ec2-user

# Install GitLab Docker image
sudo docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest

# Print completion message
echo "GitLab installation complete. Access it at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
