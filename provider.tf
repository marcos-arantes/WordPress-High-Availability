provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}
provider "kubernetes" {
  host                   = aws_eks_cluster.leads2b.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.seera.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster-name]
    command     = "aws"
  }
}



