output "RDS_instance_ip_addr" {
  value = aws_db_instance.default.endpoint
}

/* output "Hostname" {
   value = kubernetes_service.wpService.load_balancer_ingress.0.hostname
}*/