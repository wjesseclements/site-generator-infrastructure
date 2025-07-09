output "website_url" {
  description = "URL of the Company Pulse website"
  value       = "http://${aws_s3_bucket_website_configuration.company_pulse_site.website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.company_pulse_site.id
}

output "deployment_info" {
  description = "Deployment information"
  value = {
    deployment_id = var.deployment_id
    site_name     = var.site_name
    environment   = var.environment
    company_name  = var.company_name
  }
}