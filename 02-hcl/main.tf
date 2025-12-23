data "aws_s3_bucket" "my_external_bucket"{
    bucket = "not-managed-us"
}

locals {
  local_example = "This is an local variable"
}
resource "aws_s3_bucket" "name" {
  bucket = var.bucket_name
}

module "my_module" {
  source = "../01-benifits-iac"
}

