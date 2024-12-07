resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
  "Id": "Policy1733514492287",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1733514486663",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Principal": "*"
    }
  ]
  })
}
