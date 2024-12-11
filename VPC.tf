# Create VPC
resource "aws_vpc" "utc-app1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    name = "Utc-app"
    team = "Wdp"
    created_by = "Michell Okwologu"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "dev-wdp-IGW"{
  vpc_id = aws_vpc.utc-app1.id
}

# Public Subnet
resource "aws_subnet" "pub1" {
  vpc_id = aws_vpc.utc-app1.id
  availability_zone = "us-east-1a"
  cidr_block = "172.120.1.0/24"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "pub2" {
  vpc_id = aws_vpc.utc-app1.id
  availability_zone = "us-east-1b"
  cidr_block = "172.120.2.0/24"
  map_public_ip_on_launch = true
}

# Private Subnet
resource "aws_subnet" "priv1" {
  vpc_id = aws_vpc.utc-app1.id
  availability_zone = "us-east-1a"
  cidr_block = "172.120.3.0/24"
}
resource "aws_subnet" "priv2" {
  vpc_id = aws_vpc.utc-app1.id
  availability_zone = "us-east-1b"
  cidr_block = "172.120.4.0/24"
}

# Nat Gateway

resource "aws_eip" "eip1" {}

resource "aws_nat_gateway" "nat1" {
 allocation_id = aws_eip.eip1.id
 subnet_id = aws_subnet.pub1.id
}

# Private Route Table

resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.utc-app1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id

  }
}
# Public Route Table
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.utc-app1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-wdp-IGW.id

  }
}

# Public Route Table Association

resource "aws_route_table_association" "pubrt1" {
  subnet_id = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "pubrt2" {
  subnet_id = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpublic.id
}

# Private Route Table Association

resource "aws_route_table_association" "privrt1" {
  subnet_id = aws_subnet.priv1.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "privrt2" {
  subnet_id = aws_subnet.priv2.id
  route_table_id = aws_route_table.rtprivate.id
}

