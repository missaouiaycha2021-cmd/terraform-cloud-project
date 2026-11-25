#!/bin/bash
dnf update -y
dnf install -y nginx
systemctl enable --now nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

echo "<h1>Terraform Cloud Project</h1><p>Host: $(hostname) - $INSTANCE_ID</p>" \
  > /usr/share/nginx/html/index.html