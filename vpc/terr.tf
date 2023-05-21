// Cloning Terraform src code to /var/folders/14/xp776n0n51g5ts1m89_7jp380000gn/T/terraform_src...
 code has been checked out.

data "aws_region" "current" {}

locals {
  stack_name = "amazon-eks-vpc-private-subnets"
}

variable vpc_block {
  description = "The CIDR range for the VPC. This should be a valid private (RFC 1918) CIDR range."
  type = string
  default = "192.168.0.0/16"
}

variable public_subnet01_block {
  description = "CidrBlock for public subnet 01 within the VPC"
  type = string
  default = "192.168.0.0/18"
}

variable public_subnet02_block {
  description = "CidrBlock for public subnet 02 within the VPC"
  type = string
  default = "192.168.64.0/18"
}

variable private_subnet01_block {
  description = "CidrBlock for private subnet 01 within the VPC"
  type = string
  default = "192.168.128.0/18"
}

variable private_subnet02_block {
  description = "CidrBlock for private subnet 02 within the VPC"
  type = string
  default = "192.168.192.0/18"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_block
  enable_dns_support = True
  enable_dns_hostnames = True
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-VPC"
    }
  ]
}

resource "aws_internet_gateway" "internet_gateway" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_gateway_attachment" {
  vpc_id = aws_vpc.vpc.arn
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "Public Subnets"
    },
    {
      Key = "Network"
      Value = "Public"
    }
  ]
}

resource "aws_route_table" "private_route_table01" {
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "Private Subnet AZ1"
    },
    {
      Key = "Network"
      Value = "Private01"
    }
  ]
}

resource "aws_route_table" "private_route_table02" {
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "Private Subnet AZ2"
    },
    {
      Key = "Network"
      Value = "Private02"
    }
  ]
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "private_route01" {
  route_table_id = aws_route_table.private_route_table01.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway01.association_id
}

resource "aws_route" "private_route02" {
  route_table_id = aws_route_table.private_route_table02.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway02.association_id
}

resource "aws_nat_gateway" "nat_gateway01" {
  allocation_id = aws_eip.nat_gateway_eip1.allocation_id
  subnet_id = aws_subnet.public_subnet01.id
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-NatGatewayAZ1"
    }
  ]
}

resource "aws_nat_gateway" "nat_gateway02" {
  allocation_id = aws_eip.nat_gateway_eip2.allocation_id
  subnet_id = aws_subnet.public_subnet02.id
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-NatGatewayAZ2"
    }
  ]
}

resource "aws_eip" "nat_gateway_eip1" {
  // CF Property(Domain) = "vpc"
}

resource "aws_eip" "nat_gateway_eip2" {
  // CF Property(Domain) = "vpc"
}

resource "aws_subnet" "public_subnet01" {
  map_public_ip_on_launch = True
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  cidr_block = var.public_subnet01_block
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-PublicSubnet01"
    },
    {
      Key = "kubernetes.io/role/elb"
      Value = 1
    }
  ]
}

resource "aws_subnet" "public_subnet02" {
  map_public_ip_on_launch = True
  availability_zone = element(data.aws_availability_zones.available.names, 1)
  cidr_block = var.public_subnet02_block
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-PublicSubnet02"
    },
    {
      Key = "kubernetes.io/role/elb"
      Value = 1
    }
  ]
}

resource "aws_subnet" "private_subnet01" {
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  cidr_block = var.private_subnet01_block
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-PrivateSubnet01"
    },
    {
      Key = "kubernetes.io/role/internal-elb"
      Value = 1
    }
  ]
}

resource "aws_subnet" "private_subnet02" {
  availability_zone = element(data.aws_availability_zones.available.names, 1)
  cidr_block = var.private_subnet02_block
  vpc_id = aws_vpc.vpc.arn
  tags = [
    {
      Key = "Name"
      Value = "${local.stack_name}-PrivateSubnet02"
    },
    {
      Key = "kubernetes.io/role/internal-elb"
      Value = 1
    }
  ]
}

resource "aws_route_table_association" "public_subnet01_route_table_association" {
  subnet_id = aws_subnet.public_subnet01.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet02_route_table_association" {
  subnet_id = aws_subnet.public_subnet02.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet01_route_table_association" {
  subnet_id = aws_subnet.private_subnet01.id
  route_table_id = aws_route_table.private_route_table01.id
}

resource "aws_route_table_association" "private_subnet02_route_table_association" {
  subnet_id = aws_subnet.private_subnet02.id
  route_table_id = aws_route_table.private_route_table02.id
}

resource "aws_security_group" "control_plane_security_group" {
  description = "Cluster communication with worker nodes"
  vpc_id = aws_vpc.vpc.arn
}

output "subnet_ids" {
  description = "Subnets IDs in the VPC"
  value = join(",", [aws_subnet.public_subnet01.id, aws_subnet.public_subnet02.id, aws_subnet.private_subnet01.id, aws_subnet.private_subnet02.id])
}

output "security_groups" {
  description = "Security group for the cluster control plane communication with worker nodes"
  value = join(",", [aws_security_group.control_plane_security_group.arn])
}

output "vpc_id" {
  description = "The VPC Id"
  value = aws_vpc.vpc.arn
}
