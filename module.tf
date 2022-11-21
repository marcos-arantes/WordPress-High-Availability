module "aws_network" {
  source         = "./modules/aws/network"
  aws_region     = var.aws_region
}

module "aws_instance" {
  source              = "./modules/aws/aws_instance"
  sg_kubernetes_nodes = module.aws_network.sg_kubernetes_nodes
  public_subnets_id   = module.aws_network.public_subnets_id
}


module "rke_cluster" {
  source = "./modules/rancher_kubernetes"

  private_ips     = module.aws_instance.private_ips
  public_ips      = module.aws_instance.public_ips
  private_key_pem = module.aws_instance.private_key_pem
}

module "aws_load_balancer" {
  source            = "./modules/aws/elbalancer"
  sg_load_balancer  = module.aws_network.sg_load_balancer
  public_subnets_id = module.aws_network.public_subnets_id
  instance_ids      = module.aws_instance.instance_ids
}



module "kubernetes" {
  source = "./modules/k8s"

  api_server_url  = module.rke_cluster.host
  kube_admin_user = module.rke_cluster.username
  client_cert     = module.rke_cluster.client_certificate
  client_key      = module.rke_cluster.client_key
  ca_crt          = module.rke_cluster.cluster_ca_certificate
  dns_name        = module.aws_load_balancer.dns_name

}
/*
resource "aws_route53_zone" "dns-zone" {
  name = var.stage-domain
}

resource "aws_route53_record" "main-record" {
  zone_id = aws_route53_zone.dns-zone.zone_id
  name    = "${var.stage-domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.aws_load_balancer.dns_name]
}
*/