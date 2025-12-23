resource "random_id" "bucket_suffix" {
  byte_length = 7
}

resource "aws_s3_bucket" "example-bucket" {
  bucket = "example-bucket-${random_id.bucket_suffix.dec}"
}