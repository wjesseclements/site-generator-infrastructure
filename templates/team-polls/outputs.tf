output "website_url" {
  description = "URL of the Team Polls website"
  value       = "http://${aws_s3_bucket_website_configuration.team_polls_site.website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.team_polls_site.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for polls"
  value       = aws_dynamodb_table.team_polls_table.name
}

output "deployment_info" {
  description = "Deployment information"
  value = {
    deployment_id              = var.deployment_id
    site_name                  = var.site_name
    environment                = var.environment
    max_options_per_poll       = var.max_options_per_poll
    enable_anonymous_voting    = var.enable_anonymous_voting
    enable_realtime_results    = var.enable_realtime_results
  }
}