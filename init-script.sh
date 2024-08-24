#!/bin/bash

yum update -y

# Install Nginx
yum install -y nginx

# Create a basic HTML file to serve
echo "<!DOCTYPE html>
<html>
<head>
    <title>Hello, World!</title>
</head>
<body>
    <h1>Hello, World!</h1>
</body>
</html>" > /usr/share/nginx/html/index.html

# Start Nginx
systemctl start nginx

# Enable Nginx to start on boot
systemctl enable nginx