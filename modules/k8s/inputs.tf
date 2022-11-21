variable "api_server_url" {
  description = "url do server"
}
variable "kube_admin_user" {
  description = "usuario kube admin"
}
variable "client_cert" {
  description = "client value"
}
variable "client_key" {
  description = "client key cluster"
}
variable "ca_crt" {
  description = "cluster value"
}
variable "dns_name" {
  description = "Acesso do hostname"
}

variable "ns_longhorn" {
  default = "longhorn-system"
}

variable "longhorn_repo" {
  default = "https://charts.longhorn.io"
}

variable "longhorn_chart" {
  default = "longhorn"
}

variable "longhorn" {
  default = "longhorn"
}

variable "ns_wordpress" {
  default = "wordpress"
}

variable "wordpress_repo" {
  default = "https://charts.bitnami.com/bitnami"
}

variable "wordpress_chart" {
  default = "wordpress"
}
variable "wordpress_chart_version" {
  default = "15.2.16"
}

variable "wordpress" {
  default = "wordpress"
}