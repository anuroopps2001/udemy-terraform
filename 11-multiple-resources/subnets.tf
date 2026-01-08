resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  count      = var.subnet_count
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Project = local.project
    Name    = "${local.project}-${count.index}"
  }
}