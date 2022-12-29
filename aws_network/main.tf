#-----------------------------------------------------------------
# Created by Yevhen Kashuba
# December 2022
# This module create:
# - a VPC with cidr block you want;
# - public subtets in this VPC in different availability zones
# - private subnets in this VPC in different availability zones
#-----------------------------------------------------------------

/*provider "aws" {
  region = var.region
}
*/
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.name_env}-VPC"
  }
}

# Internet gateway for VPC
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.name_env}-IGW"
  }
}

# create Route Table for internet
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }
  tags = {
    Name = "${var.name_env}-Public-Routetable"
  }
}

# Association VCP with route table
resource "aws_main_route_table_association" "associate_RT_with_VPC" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.public_routetable.id
}


# Create public subnets in VPC. If you need more than 1 subnet,
# you have to add one more cidr in "var.public_subnet_cidr"
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name_env}-Public-Subnet-${count.index + 1}"
  }
}

# Association route table with public subnets
resource "aws_route_table_association" "route_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_routetable.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

# Create Elastic IPs for NAT Gateway (1 IP to 1 NAT Gateway)
resource "aws_eip" "eip_nat" {
  count = length(var.private_subnet_cidr)
  vpc   = true
  tags = {
    Name = "${var.name_env}-EIP-NAT-${count.index + 1}"
  }
}

# Create NAT Gateway for each private subnet
resource "aws_nat_gateway" "nat_gw_private_subnet" {
  count         = length(var.private_subnet_cidr)
  allocation_id = aws_eip.eip_nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name = "${var.name_env}-Nat-GW-${count.index + 1}"
  }
}

# Create private subnets in VPC. If you need more than 1 subnet,
# you have to add one more cidr in "var.private_subnet_cidr"
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.name_env}-Private-Subnet-${count.index + 1}"
  }
}

# create Route Table for private subnet to have internet
resource "aws_route_table" "private_routetable" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_private_subnet[count.index].id
  }
  tags = {
    Name = "${var.name_env}-Private-Routetable-${count.index + 1}"
  }
}
# Association route table with private subnets
resource "aws_route_table_association" "private_route_association" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_routetable[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}
