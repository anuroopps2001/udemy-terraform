// terraform.tfvars has higher precedance than variables.tf files

# ec2_instance_type = "t2.medium"

ec2_volume_config = {
  size = 35
  type = "gp3"
}

additional_tags = {
  "ValuesFrom" = "prod.terraform.tfvars"
}