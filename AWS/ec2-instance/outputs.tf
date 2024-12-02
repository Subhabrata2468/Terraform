output "instance_public_ip" {
  value = aws_instance.myec2.public_dns
  description = "public DNS of the EC2 instance"
}