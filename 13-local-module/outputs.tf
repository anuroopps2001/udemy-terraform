output "vpc_id" {
  value = module.vpc_local_module.vpc_id
}

output "public_subnets" {
  value = module.vpc_local_module.public_subnets
}

output "private_subnets" {
  value = module.vpc_local_module.private_subnets
}

output "ec2_public_hostname" {
  value = aws_instance.from_vpc_module_instance.public_dns
}

output "ec2_public_ip_address" {
  value = aws_instance.from_vpc_module_instance.public_ip
}

