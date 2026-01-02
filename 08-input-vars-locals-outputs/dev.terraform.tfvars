// terraform.tfvars has higher precedance than variables.tf files

ec2_instance_type = "t3.micro"

ec2_volume_config = {
  size = 10
  type = "gp2"
}

additional_tags = {
  "ValuesFrom" = "dev.terraform.tfvars"
}