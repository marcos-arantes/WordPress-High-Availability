
resource "aws_iam_role" "ldbr-node" {
  name = "leads-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ldbr-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ldbr-node.name
}

resource "aws_iam_role_policy_attachment" "ldbr-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ldbr-node.name
}

resource "aws_iam_role_policy_attachment" "ldbr-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ldbr-node.name
}

resource "aws_eks_node_group" "leads" {
  cluster_name    = aws_eks_cluster.leads2b.name
  node_group_name = "leads2b"
  node_role_arn   = aws_iam_role.ldbr-node.arn
  subnet_ids      = aws_subnet.leads2b[*].id
  instance_types  = ["t3.micro"]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.allow_http.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.ldbr-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ldbr-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.ldbr-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}