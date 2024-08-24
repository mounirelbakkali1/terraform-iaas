provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "web_servers_security_group" {
  name = "allow HTTP requests"
  ingress {
    description = "Allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.instance_name
  }

}

resource "aws_instance" "web_server" {
  ami           = "ami-00c39f71452c08778" # AMI IDs are region-specific
  instance_type = "t2.micro"
  #count         = 2
  depends_on      = [aws_default_vpc.default]
  user_data       = file("init-script.sh")
  key_name        = "mykeypair"
  security_groups = [aws_security_group.web_servers_security_group.name]

  tags = {
    Name = var.instance_name
  }
}