// In AWS, A VPC should normally have only ONE Internet Gateway.
resource "aws_internet_gateway" "public_igw" {
  // condition ? value_if_true : value_if_false
  count  = length(local.public_subnets) > 0 ? 1 : 0 // If there is at least one public subnet → create 1 resource Else → create 0 resources
  vpc_id = aws_vpc.this.id
}