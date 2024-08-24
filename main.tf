terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  count         = 2
  depends_on = [ aws_default_vpc.default ]

  tags = {
    Name = "web_servers"
  }
}