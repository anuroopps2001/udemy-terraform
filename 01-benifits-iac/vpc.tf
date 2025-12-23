resource "aws_vpc" "name" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "with-terraform-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private-subnet"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public-rt" {
  // Associating route table with VPC
  vpc_id = aws_vpc.name.id


  // Internet connectivity throgh IGW
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

// Making subnet public by associating it RT which has internet connectivity through IGW
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id
}