data "aws_iam_policy_document" "s3" {
  statement {
    sid = "PublicReadGetObject"  // Helps humans and AWS logs understand why the rule exists.
    actions = [
      "s3:GetObject",  // Allows read access to objects inside the bucket.
    ]
    resources = [
      "arn:aws:s3:::terraform-demo-bucket-29e83eu/*"  // applies to all objects in the bucket
    ]
    principals {
      type        = "*" // All for all the users
      identifiers = ["*"]  // ANYONE on the internet can read objects in this bucket.
    }

  }
}

output "s3_bucket_details" {
  value = data.aws_iam_policy_document.s3.json
}