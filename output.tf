output "instance_id" {
  description = "ID of the EC2 instance"
  #value       = [for instance in aws_instance.web_server : instance.public_ip]
  value = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  # value       = [for instance in aws_instance.web_server : instance.public_ip]
  value = aws_instance.web_server.public_ip
}

output "application-url" {
  #value = [for instance in aws_instance.web_server : "${aws_instance.web_server.public_ip}/index.php"]
  value = "http://${aws_instance.web_server.public_ip}"
}

output "table_name" {
  value = aws_dynamodb_table.example.name
}