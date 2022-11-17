# leads2b-desafio

Desafio de como criar uma aplicação Wordpress dentro de um cluster Kubernetes utilizando o Terraform.

Para rodar, você precisa que esteja instalado na sua máquina o Terraform v1.2+, AWS configure e o kubernetes.

No arquivo ekscluster (policy para o eks) estou criando as policies necessárias para fazermos a criação e a conexão dos recursos, configurando o Security Group
e configurando a vpc para essa policy.

