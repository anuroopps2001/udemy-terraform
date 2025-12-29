resource "aws_instance" "nginx-vpc" {
  ami = "ami-005430779df60bbaa" // AMI ID FOR NGINX"ami-005430779df60bbaa"
  // UBUNTU AMI ID:= ami-0030e4319cbf4dbf2
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  root_block_device {
    // delete ebs volume on termination of an instance
    delete_on_termination = true
    volume_size           = 10
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
  vpc_id      = aws_vpc.nginx-web-pvc.id

  tags = merge(local.common_tags, { Name = "06-resources-sg" })
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