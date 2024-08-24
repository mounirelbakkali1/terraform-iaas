provider "aws" {
  region = var.aws_region
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
    Name = "${var.instance_tag_name}-sg"
  }

}

resource "aws_instance" "web_server" {
  ami           =  var.default_instance_ami_id # AMI IDs are region-specific
  instance_type = "t2.micro"
  #count         = 2
  depends_on      = [aws_default_vpc.default]
  user_data       = file(var.user_data_file)
  key_name        = var.key_pair
  security_groups = [aws_security_group.web_servers_security_group.name]
  # vpc_security_group_ids = [ aws_security_group.web_servers_security_group.id ] also could be used to configure sg
  tags = {
    Name = var.instance_tag_name
  }
}