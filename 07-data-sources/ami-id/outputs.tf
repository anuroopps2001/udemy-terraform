output "us_east_ami_id" {
  value = data.aws_ami.ubuntu_us_east.id
}

/* output "eu_west_ami_id" {
  value = data.aws_ami.ubuntu_eu_west.id
} */


output "aws_instance_public_ip" {
  value = aws_instance.from_data_source.public_ip
}