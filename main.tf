terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.my-bucket-name
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {

  depends_on = [ 
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.example
   ]

  bucket = aws_s3_bucket.website_bucket.id
  acl = "public-read"
}

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
      "Resource": "arn:aws:s3:::${var.my-bucket-name}/*",
      "Principal": "*"
    }
  ]
  })
}

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/web-files"
  template_vars = {
    # Pass in any values that you wish to use in your templates.
    vpc_id = "vpc-abc123"
  }
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# AWS s3 object resounce for hosting bucking files 
resource "aws_s3_object" "Bucket_files" {
  bucket = aws_s3_bucket.website_bucket.id

  for_each = module.template_files.files
  key = each.key
  content_type = each.value.content_type

  source = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}