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

resource "aws_instance" "variable_instance" {
  ami = data.aws_ami.ubuntu_us_east.id
  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume_config.size
    volume_type           = var.ec2_volume_config.type
  }
  instance_type = var.ec2_instance_type

  tags = merge(var.additional_tags, { ManagedBy = "Terraform" })
}