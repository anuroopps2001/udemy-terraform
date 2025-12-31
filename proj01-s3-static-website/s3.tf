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
  tags   = merge(local.common_tags, { Name = "07-s3-static-website-bucket" })
  // To allow destruction of a non-empty bucket
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}
// Disabling public access block to expose static website hosted on s3
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls = true

  // Bucket policies won’t work if public access is blocked
  block_public_policy = false // S3 is no longer blocking public policies

  ignore_public_acls      = false
  restrict_public_buckets = false
}


// Policy to allow users to only read objects from this specific bucket
resource "aws_s3_bucket_policy" "name" {


  bucket = aws_s3_bucket.mybucket.id

  // First we need to disable the public access blocking for this bucket before attaching any policies
  depends_on = [aws_s3_bucket.mybucket, aws_s3_bucket_public_access_block.static_website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"

        // Allowing everyone to read from this bucket
        Principal = "*"

        // Allowing to access objects
        Action = "s3:GetObject"

        // Bucket from which all objects will be allowed to access
        Resource = "${aws_s3_bucket.mybucket.arn}/*"

      }
    ]
  })
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


// Adding objects into bucket 
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "build/index.html"
  // etag = filemd5("build/index.html")
  content_type = "text/html"
}
resource "aws_s3_bucket_ownership_controls" "ownershipControl" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    // For public static websites
    object_ownership = "BucketOwnerEnforced"
  }
}

