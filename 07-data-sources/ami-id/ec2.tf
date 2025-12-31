data "aws_ami" "ubuntu_us_east" {

    most_recent = true
    owners = ["099720109477"]

    filter {
        name   = "name"

        // To get all the 22 version ubuntu images
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    
}


// To get AMI in eu-west-1 region

/* data "aws_ami" "ubuntu_eu_west" {

    most_recent = true
    owners = ["099720109477"]
    provider = aws.eu_west

    filter {
        name   = "name"

        // To get all the 22 version ubuntu images
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    
} */


// Creating ubuntu ec2 from ami-ID extracted from data source

resource "aws_instance" "from_data_source" {
  ami = data.aws_ami.ubuntu_us_east.id
  associate_public_ip_address = true
  instance_type = "t3.micro"

  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp3"
  }
}