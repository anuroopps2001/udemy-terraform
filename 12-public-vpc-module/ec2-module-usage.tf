data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "using_ec2_module" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "6.2.0"
  name                   = local.name
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = data.aws_availability_zones.azs.names[0]
  vpc_security_group_ids = [module.my_vpc_from_module.default_security_group_id]

  // toset is used to convert list into an set(strings)
  /* for_each = toset(module.my_vpc_from_module.public_subnets) */

  /* subnet_id = each.key */ // we could each.value as well because set(strings) doesn;t have key or value concept and
  // terraform stores data as each.key = each.value

  subnet_id = module.my_vpc_from_module.public_subnets[0]

  tags = local.common_tags

}