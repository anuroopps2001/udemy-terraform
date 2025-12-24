resource "aws_s3_bucket" "us_east_1_bucket" {
  bucket = "us-east-1-bucket-11123764"
}

resource "aws_s3_bucket" "eu_west_1_bucket" {
  bucket = "eu-west-1-bucket-3874293033"
  // checkout the providers.tf for more info on this
  provider = aws.eu-west // Using explicit provider to create this resource
}