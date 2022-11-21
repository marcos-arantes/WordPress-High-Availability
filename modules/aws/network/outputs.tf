
output "sg_kubernetes_nodes" {
  value = aws_security_group.sg-kuber-nodes.id
}

output "sg_load_balancer" {
  value = aws_security_group.sg-loadbalancer.id
}

output "public_subnets_id" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

