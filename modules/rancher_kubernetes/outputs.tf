output "host" {
  value = rke_cluster.leads-cluster.api_server_url
}
output "username" {
  value = rke_cluster.leads-cluster.kube_admin_user
}
output "client_certificate" {
  value = rke_cluster.leads-cluster.client_cert
}
output "client_key" {
  value = rke_cluster.leads-cluster.client_key
}
output "cluster_ca_certificate" {
  value = rke_cluster.leads-cluster.ca_crt
}
