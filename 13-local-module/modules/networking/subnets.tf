data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_configuration
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
      The AZ ${each.value.az} provided for the subnet ${each.key} is Invalid..!

      The applied AWS region ${data.aws_availability_zones.available.id} Supports the following AZs:
      ${join(",", data.aws_availability_zones.available.names)}
      EOT
    }
  }
}