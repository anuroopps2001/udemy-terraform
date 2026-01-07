resource "random_id" "name" {
byte_length = 8
}
resource "aws_s3_bucket" "variable_bucekt" {
  bucket = "${local.project_name}-${random_id.name.hex}"
}