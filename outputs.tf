output "website_url" {
  description = "direct link the the website"
  value = aws_s3_bucket_website_configuration.web_config.website_endpoint
}
