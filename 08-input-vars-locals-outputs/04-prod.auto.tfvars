// *.auto.tfvars files have higher precedence over the terrraform.tfvars file and other it's related files
# ec2_instance_type = "t2.micro"



additional_tags = {
  ValuesFrom = "prod.auto.tfvars"
}