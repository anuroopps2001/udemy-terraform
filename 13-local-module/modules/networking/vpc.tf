resource "aws_vpc" "this" {
  cidr_block = var.vpc_configuration.cidr_block
  tags = {
    Name = var.vpc_configuration.name
  }
}
