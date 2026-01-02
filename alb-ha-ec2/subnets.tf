locals {
  common_tags = {
      Managed_by = "terraform"
    Project = "alb-ha-ec2-go-app"
  }
  }

  data "aws_" "name" {
    
  }


resource "aws_subnet" "public-subnet-01" {
  vpc_id = aws_vpc.ha-vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-subnet-02" {
  vpc_id = aws_vpc.ha-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  
}