output "RDS_instance_ip_addr" {
  value = aws_db_instance.default.endpoint
}
