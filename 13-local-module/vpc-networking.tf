module "vpc_local_module" {
  source = "./modules/networking"

  vpc_configuration = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules"
  }

  subnet_configuration = {
    subnet_1 = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
    }

    subnet_2 = {
      cidr_block = "10.0.2.0/24"
      public     = true
      az         = "us-east-1b"
    }
  }
}