output "dns_acess" {
  value = format("A URL do seu site Wordpress: %s", module.aws_load_balancer.dns_name)
}

/*
output "website_wordpress" {
  value = format("A URL do seu site Wordpress: %s", var.stage-domain)
}

*/