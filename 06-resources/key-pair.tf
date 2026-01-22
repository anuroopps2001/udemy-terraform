// Key pair creation
resource "tls_private_key" "keypair_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "my-kp"
  public_key = trimspace(tls_private_key.keypair_private_key.public_key_openssh)
}


// To download .pem file to local system
resource "local_sensitive_file" "pem_file" {
  filename        = pathexpand("C:/Users/ANUROOP P S/.ssh/${aws_key_pair.keypair.key_name}.pem")
  file_permission = "600"
  content         = tls_private_key.keypair_private_key.private_key_pem
}