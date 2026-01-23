locals {
  name = "12-public-module"

  common_tags = {
    Name      = local.name
    Project   = "12-public-modules"
    ManagedBy = "Terraform"
  }
}