locals {
  docker = file("${path.module}/scripts/install_jenkins.sh")
  // jenkins = file("${path.module}/scripts/install_jenkins.sh")
  docker_compose = file("${path.module}/scripts/docker_compose_install.sh")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "nginx-ec2-instance" {
  ami = data.aws_ami.ubuntu.id // AMI ID FOR NGINX"ami-005430779df60bbaa"
  // UBUNTU AMI ID:= ami-0030e4319cbf4dbf2
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id


  # This is one way of reading multiple files into an instance using user_data
  /* user_data = templatefile("${path.module}/user_data.tpl",{
    docker_instal = file("${path.module}/scripts/docker_install.sh")
    jenkins_install = file("${path.module}/scripts/install_jenkins.sh")
  }
  ) */


  # This is using locals and using data into ec2 with user_data 
  user_data = templatefile("${path.module}/user_data.tpl", {
    docker_install = local.docker
    // jenkins_install = local.jenkins
    docker_compose_install = local.docker_compose
  })

  // key_name argument causes the instance to be replaced (destroyed and recreated) if changed
  depends_on = [aws_key_pair.keypair]
  key_name   = aws_key_pair.keypair.key_name


  root_block_device {
    // delete ebs volume on termination of an instance
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  tags                   = merge(local.common_tags, { Name = "06-resources-ec2-instance" })

  // To create an resource before destruction of old instance or resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags] /* A set of fields (references) of which to ignore changes to, so that manually made chanes
    stay intact and terraform won;t try to revert the changes based on the configuration file details */
  }
}


resource "aws_security_group" "nginx-sg" {
  name        = "06-resources-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.nginx-web-vpc.id

  tags = merge(local.common_tags, { Name = "06-resources-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "nginx-ipv4-ssh" {
  security_group_id = aws_security_group.nginx-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "nginx-ipv4-http" {
  security_group_id = aws_security_group.nginx-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "nginx-ipv4-https" {
  security_group_id = aws_security_group.nginx-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "nginx-ipv4-jenkins-access" {
  security_group_id = aws_security_group.nginx-sg.id
  cidr_ipv4         = "0.0.0.0/0"

  // from_port refers to the destination port on your EC2 instance
  from_port   = 8080
  ip_protocol = "tcp"

  // Allow traffic TO port 8080 on this instance
  to_port = 8080
}

resource "aws_vpc_security_group_egress_rule" "name" {
  security_group_id = aws_security_group.nginx-sg.id

  /* -1 → all protocols
    All ports
    All destinations */
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

output "jekins_ip_address" {
  value = aws_instance.nginx-ec2-instance.public_ip
}