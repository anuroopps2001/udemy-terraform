locals {
  public_subnets = {
    for key, config in var.subnet_configuration : key => config if config.public # execute only if config.public == true
  }

  private_subnets = {
    for key, config in var.subnet_configuration : key => config if !config.public
  }

  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id = aws_subnet.this[key].id
      az        = aws_subnet.this[key].availability_zone
    }
  }


  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id = aws_subnet.this[key].id
      az        = aws_subnet.this[key].availability_zone
    }
  }
}