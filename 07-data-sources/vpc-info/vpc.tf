// variable "vpc_id" {}

data "aws_vpc" "selected"{
default = true
}
output "vpc_arn" {
  value = data.aws_vpc.selected
}