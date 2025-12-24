resource "aws_vpc" "nginx-web-pvc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "nginx-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.nginx-web-pvc.id
  cidr_block = "10.0.1.0/24" // 256 IPs starting from 10.0.1.1 - 10.0.1.254 and network & broadcast IPs
  tags = {
    Name = "nginx-public-subnet"
  }
}

// Internet gateway
resource "aws_internet_gateway" "nginx-igw" {
  vpc_id = aws_vpc.nginx-web-pvc.id
  tags = {
    Name = "ngninx-igw"
  }
}

// Route table
resource "aws_route_table" "ngninx-route-table" {
  vpc_id = aws_vpc.nginx-web-pvc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-igw.id
  }

  tags = {
    Name = "nginx-rt"
  }
}

resource "aws_route_table_association" "rt-association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.ngninx-route-table.id
}