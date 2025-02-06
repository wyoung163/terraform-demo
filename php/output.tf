output "instance-public-ip" {
  value = aws_instance.php-example.public_ip
  description = "Public IP of php server"
}
