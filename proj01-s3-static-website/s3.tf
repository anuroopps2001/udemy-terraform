locals {
  common_tags = {
    Managed_by = "terraform"
    Project    = "07-s3-static-website"
  }
}


resource "random_id" "name" {
  byte_length = 4
}
resource "aws_s3_bucket" "mybucket" {
  bucket = "random-bucket-created-by-terraform-${random_id.name.hex}"
  tags = merge(local.common_tags, { Name = "07-s3-static-website-bucket" })
  // To allow destruction of a non-empty bucket
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_policy" "name" {


  bucket = aws_s3_bucket.mybucket.id

  depends_on = [ aws_s3_bucket_public_access_block.name ]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket.arn}/*"

      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "ownershipControl" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    // For public static websites
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "name" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls = true

  // Bucket policies won’t work if public access is blocked
  block_public_policy = false // S3 is no longer blocking public policies

  ignore_public_acls      = true
  restrict_public_buckets = false
}


// static web hosting from an s3
resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "build/index.html"
  // etag = filemd5("Downloads/index.html")
  content_type = "text/html"
}