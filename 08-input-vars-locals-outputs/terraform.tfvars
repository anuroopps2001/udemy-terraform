// terraform.tfvars file has higher precedance than any other .tfvars files and variables.tf file

ec2_instance_type = "t3.micro"

ec2_volume_config = {
  size = 10
  type = "gp3"
}

additional_tags = {
  ValuesFrom = "terraform.tfvars"
}