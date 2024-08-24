output "instance_ids" {
  description = "ID of the EC2 instance"
  value       = [for instance in aws_instance.web_server : instance.public_ip]
}

output "instance_public_ips" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in aws_instance.web_server : instance.public_ip]
}