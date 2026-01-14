locals {
  ami_ids = {
    ubuntu = data.aws_ami.ubuntu_us_east.id
    nginx  = data.aws_ami.nginx.id
  }
}

data "aws_ami" "nginx" {
  most_recent = true
  filter {
    name   = "image-id"
    values = ["ami-01e8e2269458f4b3c"]
  }
  filter {
    name   = "name"
    values = ["bitnami-nginx-1.28.1-*-debian-12-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu_us_east" {

  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"

    // To get all the 22 version ubuntu images
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
resource "aws_instance" "from_count" {
  ami           = data.aws_ami.ubuntu_us_east.id
  instance_type = "t3.micro"
  count         = var.instance_count                                            // 4
  subnet_id     = aws_subnet.subnet[count.index % length(aws_subnet.subnet)].id // Modules Operator
  # 0 % 2 = 0
  # 1 % 2 = 1
  # 2 % 2 = 0
  # 3 % 2 = 1 
  tags = {
    Project = local.project
    Name    = "${local.project}-${count.index}"
  }
}

resource "aws_instance" "ec2_instance_from_list" {
  count = length(var.ec2_instance_config_list)
  ami   = local.ami_ids[var.ec2_instance_config_list[count.index].ami] // This line says, I will not decide the AMI here. Instead
  // I will take the AMI choice only from input variables or through .tfvars files

  // local.ami_ids[var.ec2_instance_config_list[count.index].ami] will evaluate based on .tfvars file we pass and that file should contain
  // filed caled "ami"

  // Ex:- 
  /* 
  variable "ami" {
  type = string
  }

  locals {
    ami_ids = {
      ubuntu       = data.aws_ami.ubuntu.id
      amazon-linux = data.aws_ami.amazon_linux.id
    }
  } 
  */

  /* 
  Case 1: Dev environment
  dev.tfvars
  ami = "ubuntu"

  Apply
  terraform apply -var-file=dev.tfvars

  Terraform evaluates:

  ami = local.ami_ids["ubuntu"]


  ➡ Ubuntu AMI is used. */

  /* 
  Case 2: Prod environment
  prod.tfvars
  ami = "amazon-linux"

  Apply
  terraform apply -var-file=prod.tfvars


  Terraform evaluates:

  ami = local.ami_ids["amazon-linux"]


  ➡ Amazon Linux AMI is used. */



  instance_type = var.ec2_instance_config_list[count.index].instance_type
  subnet_id     = aws_subnet.subnet["default"].id

  tags = {
    Name    = "${local.project}-${count.index}"
    Project = local.project
  }
}

resource "aws_instance" "ec2_instance_from_map" {
  # each.key   => holds the key of each key-value pair in the map 
  # each.value => holds the value(object) of each key-value pair in the map
  # using each.value, we can extract atributes of that value/object in the map

  // In the map below
  /*  ec2_instance_config_map = {  --> map name
  "ubuntu_1" = {                  --> key in the map
    instance_type = "t3.micro"    --> attributes of an value
    ami           = "ubuntu"
  },
  "nginx_1" = {
    instance_type = "t2.micro"
    ami           = "nginx"
    subnet_index  = 1
  }

} */
  for_each      = var.ec2_instance_config_map
  ami           = local.ami_ids[each.value.ami]
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.subnet_from_map[each.value.subnet_name].id

  tags = {
    Name    = "${local.project}-${each.key}"
    Project = "${local.project}-${each.value.subnet_index}"
  }
}