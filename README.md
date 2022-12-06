
Criando uma aplicação Wordpress em alta disponibilidade com Kubernetes, Helm e AWS
 
Então para montarmos essa infra com essa aplicação, nós a dividimos em três partes (módulos).
 
Primeiro módulo "aws", dentro dele tem mais três divisões:
Começa pela "aws_instance" que basicamente estamos criando nossas instâncias onde ficará o cluster kubernetes. Aqui definimos o tipo da imagem que vamos usar; no caso estamos usando a imagem do Ubuntu. Quais subnetes vamos usar, qual security group. Além disso, vamos criar uma chave privada para podermos fazer conexões ssh depois com as instâncias.
Depois vamos para "elbalancer", aqui estamos criando um balanceador de carga para as nossas instâncias e atachando.
Ainda no módulo "aws" temos a última parte, que é a parte de rede (network). Aqui vamos criar toda a infraestrutura de rede da nossa aplicação, a vpc, as zonas de disponibilidade, as subnets, os security groups, o internet gateway e as tabelas de rotas para nossa vpc.
 
No segundo módulo reservamos para o "k8s", que é composto por alguns arquivos:
"helm-longhorn.tf" aqui estamos configurando nosso longhorn para o nosso kubernetes.
Em "providers.tf" estamos configurando o provider do kubernetes e do helm; então certificado, usuário do kubernetes etc.
Em "wordpress.tf" é onde pegamos vamos pegar o pacote do wordpress com o helm, além de atribuir as variáveis corretas para que funcione a aplicação wordpress.
 
No terceiro módulo e não menos importante, vamos configurar o cluster dentro das instâncias criadas. Então aqui estamos criando o cluster com o número de nós que você precisa, o tipo de acesso a esses nós (ip privado e publico), o tipo de rede, o tamanho que ele pode aumentar etc. (rke_cluster.tf)
 
Agora que criamos esses três módulos precisamos chamar eles para eles serem executados.
 
Para isso temos um arquivo chamado "module.tf" onde vai chamar primeiro, o módulo de rede onde vai criar nossa rede na AWS. Depois chamamos o "aws_instance" onde vai ser criado as instâncias EC2 Ubuntu. E depois temos o "rancher_kurbernetes" onde vai criar os cluster dentro das instâncias. Logo em seguida vem o "elbalancer" onde vai fazer a criação do load balancer e atribuição das instâncias. Feito tudo isso vem o k8s que nada mais nada menos é configuração do pacote helm (wordpress) no cluster kubernetes.
Ainda no "module.tf" uma configuração para o route53, justamente para você pegar o endpoint do load balancer e atribuir para o seu domínio. (vou deixar essa parte comentada pois não vou usar agora)
 
Além desses pontos temos um "providers.tf" onde estamos especificando qual cloud vamos usar e qual versão.
