# leads2b-desafio

Desafio de como criar uma aplicação Wordpress dentro de um cluster Kubernetes utilizando o Terraform.

Para rodar, você precisa que esteja instalado na sua máquina o Terraform v1.2+, AWS configure e o kubernetes.

No arquivo ekscluster.tf (policy para o eks) estou criando as policies necessárias para fazermos a criação e a conexão dos recursos, configurando o Security Group e configurando a vpc para essa policy.

O arquivo eksworkernodes.tf nós utilizamos para criar policies, mas também configurar o node group do eks.

No arquivo kubernetesconfigurations.tf estou montando um volume dentro do cluster para armazenar uma parte do wordpress, eu faço o deploy nesse volume (pvc), criando duas réplicas dentro desse volume. A outra parte do wordpress é a parte de banco de dados, que estamos armazenando no RDS.

No output.tf por enquanto só deixei um retorno, que basicamente o endpoint do RDS depois de criado.

Em provider.tf estamos configurando qual cloud estamos utilizando, a região, a zona de disponibilidade, tipo de conexão; como também estamos configurando nosso kubernetes, qual é o host, criamos um certificado para o cluster, e sobre api que coloquei dentro do kubernetes é justamente porque o token expira a cada 15 minutos, essa api de autenticação faz a renovação do token automaticamente.

No rds.tf o que estamos fazendo é montar uma máquina RDS na AWS, qual é o tipo banco, o tamanho, versão etc.

Em security-grp.tf estou montando regras de entrada e saída entre nossa aplicações e recursos. Configurando quais range de ip pode entrar na nossa VPC.

Em variables.tf estamos criando variávies como região, nome de cluster, ssh chave (a chave do ssh deve ser criado lá no ec2) etc.

Em version.tf estamos configurando a versão do terraform e a versão da hashicorp/AWS; fazemos isso para na hora de rodar o terraform em outra máquina não dar conflito de versão.

Em vpc.tf estamos fazendo a configuração da nossa rede dentro da AWS. Estamos criando VPC, subnets, internet gateway (para as subnetes terem acesso externo) e também uma tabela de rotas.


