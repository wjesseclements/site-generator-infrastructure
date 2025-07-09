output "website_url" {
  description = "URL of the PixelWorks website"
  value       = "http://${aws_s3_bucket_website_configuration.pixelworks_site.website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.pixelworks_site.id
}

output "deployment_info" {
  description = "Deployment information"
  value = {
    deployment_id = var.deployment_id
    site_name     = var.site_name
    environment   = var.environment
    theme         = var.theme
  }
}