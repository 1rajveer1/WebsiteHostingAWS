resource "aws_s3_bucket_acl" "bucket_acl" {

  depends_on = [ 
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.example
   ]

  bucket = aws_s3_bucket.website_bucket.id
  acl = "public-read"
}