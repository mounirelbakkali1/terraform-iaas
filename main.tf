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

resource "aws_security_group" "web_servers_security_group_audit" {
  name = "allow-ssh-connection"  
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
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
    Name = "${var.instance_tag_name}-sg-audit"
  }

}

resource "aws_instance" "web_server" {
  ami           = var.default_instance_ami_id # AMI IDs are region-specific
  instance_type = "t2.micro"
  #count         = 2
  depends_on      = [aws_default_vpc.default]
  user_data       = file(var.user_data_file)
  key_name        = var.key_pair
  security_groups = [aws_security_group.web_servers_security_group.name , aws_security_group.web_servers_security_group_audit.name]
  # vpc_security_group_ids = [ aws_security_group.web_servers_security_group.id ] also could be used to configure sg

  iam_instance_profile = aws_iam_instance_profile.web_server_profile.name # assign dynamodb_access_role
  tags = {
    Name = var.instance_tag_name
  }
}

resource "aws_iam_instance_profile" "web_server_profile" {
  name = "web_server_profile"
  role = aws_iam_role.dynamodb_access_role.name
}

resource "aws_dynamodb_table" "example" {
  name         = "example-table"
  billing_mode = "PAY_PER_REQUEST" # (On-Demand)

  hash_key  = "id"
  range_key = "createdAt"


  dynamic "attribute" {
    for_each = var.example_table_attributes
    content {
      name = attribute.key
      type = attribute.value.type
    }
  }

  # dynamic global secondary index definition
  dynamic "global_secondary_index" {
    for_each = var.example_global_secondary_indexes
    content {
      name            = global_secondary_index.key
      hash_key        = global_secondary_index.value.hash_key
      range_key       = lookup(global_secondary_index.value, "range_key", null)
      projection_type = global_secondary_index.value.projection_type
    }
  }
  # global_secondary_index {
  #   name               = "CategoryIndex"
  #   hash_key           = "category"
  #   projection_type    = "ALL"
  # }
  tags = {
    Name = "example-dynamodb-table"
  }
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "DynamoDBAccessPolicy"
  description = "Policy to allow access to DynamoDB table"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
        ],
        Resource = aws_dynamodb_table.example.arn,
      },
    ],
  })
}


resource "aws_iam_role" "dynamodb_access_role" {
  name = "dynamodb_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.dynamodb_access_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}
