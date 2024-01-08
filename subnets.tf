resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  # CIDR block for the subnet
  cidr_block = "192.168.0.0/18"

  availability_zone = "us-east-1a"
  # Ensure that every new instance launched get associated public IP
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-us-east-1a"
    "kubernetes.io/clusters/eks" = "shared"
    "kubernetes.io/role/elb"     = 1
  }

}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  # CIDR block for the subnet
  cidr_block = "192.168.64.0/18"

  availability_zone = "us-east-1b"
  # Ensure that every new instance launched get associated public IP
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-us-east-1b"
    "kubernetes.io/clusters/eks" = "shared"
    "kubernetes.io/role/elb"     = 1
  }

}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  # CIDR block for the subnet
  cidr_block = "192.168.128.0/18"

  availability_zone = "us-east-1a"

  tags = {
    Name                              = "private-us-east-1a"
    "kubernetes.io/clusters/eks"      = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  # CIDR block for the subnet
  cidr_block = "192.168.192.0/18"

  availability_zone = "us-east-1b"

  tags = {
    Name                              = "private-us-east-1b"
    "kubernetes.io/clusters/eks"      = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}