# Outputs for Test Template

output "site_url" {
  description = "URL of the deployed website"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "deployment_info" {
  description = "Deployment information"
  value = {
    deployment_id = var.deployment_id
    site_name     = var.site_name
    environment   = var.environment
    template      = "test-template"
    bucket_name   = aws_s3_bucket.website.id
    website_url   = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }
  sensitive = false
}