output "vpc_id" {
  value = aws_vpc.this.id
}

// output public subnets id and az details
output "public_subnets" {
  value = local.output_public_subnets
}

// output private subnets id, and az details
output "private_subnets" {
  value = local.output_private_subnets
}

// private_subnets_list
output "private_subnets_ids_list" {
  value = [for i in aws_subnet.this : i.id] 
}