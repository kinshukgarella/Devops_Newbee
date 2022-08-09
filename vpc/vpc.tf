
resource "aws_vpc" "vpc_cidr_block" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink

  tags = {
      Name = var.tags
    }

}

//Private Subnet
resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc_cidr_block.id
  map_public_ip_on_launch = false
  cidr_block = var.private_subnet_1_cidr
  

  tags = {
    Name = "private_1"
  }
}
resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc_cidr_block.id
  map_public_ip_on_launch = false
  cidr_block = var.private_subnet_2_cidr

  tags = {
    Name = "private_2"
  }
}

//NAT for Private Subnet
resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_route_table" "route_private" {
  vpc_id = "${aws_vpc.vpc_cidr_block.id}"

  route {
    cidr_block = var.default_subnet
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}
resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}


//Public Subnet
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc_cidr_block.id
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_1_cidr

  tags = {
    Name = "public_1"
  }
}
resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc_cidr_block.id
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_2_cidr

  tags = {
    Name = "public_2"
  }
}


//Route Table
resource "aws_route_table" "route-public" {
  vpc_id = "${aws_vpc.vpc_cidr_block.id}"

  route {
    cidr_block = var.default_subnet
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.route-public.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.route-public.id}"
}

//Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_cidr_block.id}"

  tags = {
    Name = "internet-gateway"
  }
}
