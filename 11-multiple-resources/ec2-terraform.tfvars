subnet_count   = 3
instance_count = 0
ec2_instance_config_list = [
  /* {
    instance_type = "t3.micro"
    ami           = "ubuntu"
  },
  {
    instance_type = "t2.micro"
    ami           = "nginx"
  } */
]

ec2_instance_config_map = {
  "ubuntu_1" = {
    instance_type = "t3.micro"
    ami           = "ubuntu"
  },
  "nginx_1" = {
    instance_type = "t2.micro"
    ami           = "nginx"
    subnet_index  = 1
  }

}