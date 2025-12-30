locals {
  common_tags = {
    Managed_by = "terraform"
    Project    = "oc-resources"
  }
}


resource "aws_vpc" "nginx-web-pvc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  // merge is an builtin function takes 2 args and merge them
  tags = merge(local.common_tags, { Name = "06-resources-vpc" })
}

// Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.nginx-web-pvc.id
  cidr_block = "10.0.1.0/24" // 256 IPs starting from 10.0.1.1 - 10.0.1.254 and network & broadcast IPs
  tags       = merge(local.common_tags, { Name = "06-resources-public-subnet" })
}

// Internet gateway
resource "aws_internet_gateway" "nginx-igw" {
  vpc_id = aws_vpc.nginx-web-pvc.id
  tags   = merge(local.common_tags, { Name = "06-resources-igw" })
}

// Route table
resource "aws_route_table" "ngninx-route-table" {
  vpc_id = aws_vpc.nginx-web-pvc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-igw.id
  }

  tags = merge(local.common_tags, { Name = "06-resources-rt" })
}

// route-table association of public subnet with igw
resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.ngninx-route-table.id

}