locals {
  common_tags= {
    Managed_by = "terraform"
    Project = "alb-ha-ec2-go-app"
  }
}
resource "aws_vpc" "ha-vpc" {
  cidr_block = "10.0.0.0/16"  // 65536 IPs
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(local.common_tags, {Name = "go-db-app-vpc"})
}