variable "region" {
  default = "ap-south-1"
  type    = string
}

variable "cluster-name" {
  default = "leads2b-eks-cluster"
  type    = string
}
variable "RDS_name" {
  default = "leadsRDS"
  type    = string
}
variable "RDS_username" {
  default = "leads"
  type    = string
}
variable "RDS_password" {
  default = "d546MccA8"
  type    = string
}
variable "ssh_key_name" {
  default = "chave" // Essa chave deve estar criada no EC2, na região que você escolheu
  type    = string
}