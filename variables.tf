variable "instance_tag_name" {
  description = "value of tag name of ec2 instance"
  type        = string
  default     = "web_server"
}

variable "user_data_file" {
  type = string
  default = "init-script.sh"
  validation {
    condition = length(regexall(".*\\.sh$", var.user_data_file)) > 0
    error_message = "user data file path should be bash script file with .sh extension"
  }
}

variable "default_instance_ami_id" {
  description = "Default Instance AMI ID"
  type = string
  default = "ami-00c39f71452c08778"
}

variable "key_pair" {
  type = string
  default = "mykeypair"
}


variable "aws_region" {
  type = string
  default = "us-east-1"
  description = "AWS region"
}