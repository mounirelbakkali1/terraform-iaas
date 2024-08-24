#!/bin/bash
sudo yum update -y

sudo yum install java  -y
sudo yum install java-devel -y

# Install Git
sudo yum install git -y

# Clone the Git repository containing the Spring Boot project
cd /home/ec2-user
git clone https://github.com/mounirelbakkali1/spring-dynamodb-rest

cd spring-dynamodb-rest

sudo chmod +x mvnw

sudo ./mvnw clean package

sudo java -jar target/application.jar > /dev/null 2>&1 &

echo "Spring Boot Application Setup Completed" > /tmp/spring-boot-setup-result.txt
