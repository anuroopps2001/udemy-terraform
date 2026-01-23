locals {
  vpc_cidr            = "10.0.0.0/16"
  vpc_private_subnets = ["10.0.1.0/24"]
  vpc_public_subnets  = ["10.0.101.0/24"]
}
data "aws_availability_zones" "azs" {
  state = "available"
}
module "my_vpc_from_module" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name            = local.name
  cidr            = local.vpc_cidr
  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  tags = local.common_tags


  public_subnet_tags = {
    Name = "12-public-module-public-subnet"
  }

  private_subnet_tags = {
    Name = "12-public-module-private-subnet"
  }
}