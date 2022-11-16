# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table

resource "aws_vpc" "leads2b" {
  cidr_block = "192.168.0.0/23"

  tags = {
    "Name" = "leads-eks-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_subnet" "leads2b" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "192.168.${count.index}.0/25"
  vpc_id            = aws_vpc.leads2b.id
  map_public_ip_on_launch = true

  tags = {
    "Name" = "leads-eks-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "leads2b" {
  vpc_id = aws_vpc.leads2b.id

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_route_table" "leads2b" {
  vpc_id = aws_vpc.leads2b.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.leads2b.id
  }
}

resource "aws_route_table_association" "leads2b" {
  count = 2

  subnet_id      = aws_subnet.leads2b.*.id[count.index]
  route_table_id = aws_route_table.leads2b.id
}