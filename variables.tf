variable "region" {
  default = "us-west-2"
  type = string
}

variable "cluster-name" {
  default = "ldbr-node"
  type    = string
}
variable "RDS_name"{
  default = "leadsRDS"
  type = string
}
variable "RDS_username"{
  default = "leadstwob"
  type = string
}
variable "RDS_password"{
  default = "eisq2fnm"
  type = string
}
variable "ssh_key_name"{
  default = "chave"    //Usa uma chave ssh criada lá no EC2
  type = string
}