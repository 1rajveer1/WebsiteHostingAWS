resource "aws_s3_object" "Bucket_files" {
  bucket = aws_s3_bucket.website_bucket.id

  for_each = var.files
  key = each.key
  content_type = each.value.content_type

  # Use 'content' to upload the file content
  content = each.value.content

  etag = each.value.digests
}
