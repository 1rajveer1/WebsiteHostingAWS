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

module "s3" {
  source      = "./s3"
  bucket_name = var.my-bucket-name
  files = {
    "index.html" = {
      content_type = "text/html"
      content      = file("${path.module}/web-files/index.html")  # Load content of index.html
      digests      = md5(file("${path.module}/web-files/index.html"))  # Compute MD5 hash
      source_path  = "${path.module}/web-files/index.html"  # Local path to the file
    },
    "error.html" = {
      content_type = "text/html"
      content      = file("${path.module}/web-files/error.html")  # Load content of error.html
      digests      = md5(file("${path.module}/web-files/error.html"))  # Compute MD5 hash
      source_path  = "${path.module}/web-files/error.html"  # Local path to the file
    }
  }
  
}

output "website_url" {
  value = module.s3.website_url
}
