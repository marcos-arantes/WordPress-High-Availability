variable "private_ips" {
  default = "Ips privados"
}

variable "public_ips" {
  description = "Ips publicos"
}

variable "private_key_pem" {
  description = "Chave privada"
}

variable "cluster_name" {
  type    = string
  default = "leads2b-cluster"
}

variable "kube_version" {
  default = "v1.22.4-rancher1-1"
}
