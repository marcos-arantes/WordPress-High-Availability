resource "aws_iam_role" "cluster-leads2b" {
  name = "leads-eks-cluster"

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

resource "aws_iam_role_policy_attachment" "leads2b-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-leads2b.name
}

resource "aws_iam_role_policy_attachment" "leads2b-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster-leads2b.name
}

resource "aws_security_group" "leads2b-sg" {
  name        = "leads-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.leads2b.id

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

resource "aws_security_group_rule" "leads2b-cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.leads2b-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "leads2b" {
  name     = var.cluster-name
  role_arn = aws_iam_role.cluster-leads2b.arn

  vpc_config {
    security_group_ids = [aws_security_group.leads2b-sg.id]
    subnet_ids         = aws_subnet.leads2b[*].id
  }


  depends_on = [
    aws_iam_role_policy_attachment.leads2b-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.leads2b-cluster-AmazonEKSServicePolicy,
  ]
}