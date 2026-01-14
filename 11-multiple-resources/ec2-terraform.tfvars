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
    instance_type = "t2.micro"
    ami           = "ubuntu"
    subnet_name = "subnet_1"
  },
  "nginx_1" = {
    instance_type = "t2.micro"
    ami           = "nginx"
    subnet_index  = 1
  }

}

subnet_map = {
  default = {
    cidr_block = "10.0.1.0/24"
  },
  subnet_1 = {
    cidr_block = "10.0.2.0/24"
  }
}