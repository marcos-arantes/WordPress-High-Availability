resource "aws_iam_role" "leads2b-iam" {
  name = "leads-eks-cluster-iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "leads-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.leads2b-iam.name
}

resource "aws_iam_role_policy_attachment" "leads-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.leads2b-iam.name
}

resource "aws_security_group" "leads-sg" {
  name        = "leads-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.leads-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-leads"
  }
}

resource "aws_security_group_rule" "leads-cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.leads-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "leads2b" {
  name     = var.cluster-name
  role_arn = aws_iam_role.leads2b-iam.arn

  vpc_config {
    security_group_ids = [aws_security_group.leads-sg.id]
    subnet_ids         = aws_subnet.leads[*].id
  }


  depends_on = [
    aws_iam_role_policy_attachment.leads-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.leads-cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = aws_eks_cluster.leads2b.identity.0.oidc.0.issuer
}