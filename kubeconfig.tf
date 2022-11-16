resource "null_resource" "kube_configuration" {
    provisioner "local-exec" {
    command = "aws eks --region us-west-2 update-kubeconfig --name leads-eks-cluster"
  }
}