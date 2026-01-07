output "bucket_name" {
  value = aws_s3_bucket.variable_bucekt.bucket
}

output "sensitive_output" {
  sensitive = true
  value = var.sensitive_variable
}