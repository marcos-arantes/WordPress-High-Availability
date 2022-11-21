resource "aws_security_group" "sg-kuber-nodes" {
  name        = "k8s-nodes-sg"
  description = "Permitindo acesso de ssh de entrada e de saida"
  vpc_id      = aws_vpc.leads-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-nodes-sg"
  }
}

resource "aws_security_group" "sg-loadbalancer" {
  name        = "k8s-lb-sg"
  description = "Permitindo acesso ssh de http da internet"
  vpc_id      = aws_vpc.leads-vpc.id

  ingress {
    description      = "Acesso http para internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Acesso https para internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Permitindo todo trafego de saida"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "k8s-lb-sg"
  }
}