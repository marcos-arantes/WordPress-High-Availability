resource "aws_vpc" "leads-vpc" {
  cidr_block = "192.168.0.0/23"

  tags = {
    "Name"                                      = "leads-eks-cluster-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_subnet" "leads" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "192.168.${count.index}.0/25"
  vpc_id                  = aws_vpc.leads-vpc.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "leads-eks-cluster-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "leads-ig" {
  vpc_id = aws_vpc.leads-vpc.id

  tags = {
    Name = "terraform-eks-leads-ig"
  }
}

resource "aws_route_table" "leads-rt" {
  vpc_id = aws_vpc.leads-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.leads-ig.id
  }
}

resource "aws_route_table_association" "leads-rta" {
  count = 2

  subnet_id      = aws_subnet.leads.*.id[count.index]
  route_table_id = aws_route_table.leads-rt.id
}