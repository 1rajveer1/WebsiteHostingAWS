variable "bucket_name" {
  description = "name of the bucket"
  type = string
}

variable "files" {
  description = "Map of files to upload to S3"
  type = map(object({
    content_type = string
    content      = string
    digests      = string
    source_path  = string
  }))
}