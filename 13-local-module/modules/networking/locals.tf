locals {
  public_subnets = {
    for key, config in var.subnet_configuration : key => config if config.public # execute only if config.public == true
  }
}