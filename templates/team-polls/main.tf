terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# S3 bucket for the Team Polls website
resource "aws_s3_bucket" "team_polls_site" {
  bucket = "${var.site_name}-team-polls-${var.deployment_id}"

  tags = merge(var.tags, {
    Name = "${var.site_name} Team Polls"
    Type = "Website"
  })
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "team_polls_site" {
  bucket = aws_s3_bucket.team_polls_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 bucket public access block (disabled for website hosting)
resource "aws_s3_bucket_public_access_block" "team_polls_site" {
  bucket = aws_s3_bucket.team_polls_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket policy for public read access
resource "aws_s3_bucket_policy" "team_polls_site" {
  bucket = aws_s3_bucket.team_polls_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.team_polls_site.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.team_polls_site]
}

# DynamoDB table for storing polls and votes
resource "aws_dynamodb_table" "team_polls_table" {
  name         = "${var.site_name}-team-polls-${var.deployment_id}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "poll_id"
  range_key    = "item_type"

  attribute {
    name = "poll_id"
    type = "S"
  }

  attribute {
    name = "item_type"
    type = "S"
  }

  tags = merge(var.tags, {
    Name = "${var.site_name} Team Polls Table"
  })
}

# Upload a simple HTML file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.team_polls_site.id
  key          = "index.html"
  content_type = "text/html"
  
  content = <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${var.site_name} - Team Polls</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f0f8ff; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        h1 { color: #2c5aa0; }
        .status { background: #e8f4fd; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #2c5aa0; }
        .poll-info { background: #f8f9fa; padding: 15px; border-radius: 6px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${var.site_name} - Team Polls</h1>
        <div class="status">
            <h2>📊 Deployment Successful!</h2>
            <p>Your Team Polls application has been successfully deployed using the Site Generator Platform.</p>
            <p><strong>Deployment ID:</strong> ${var.deployment_id}</p>
            <p><strong>Environment:</strong> ${var.environment}</p>
        </div>
        <div class="poll-info">
            <h3>Configuration</h3>
            <p><strong>Max Options per Poll:</strong> ${var.max_options_per_poll}</p>
            <p><strong>Anonymous Voting:</strong> ${var.enable_anonymous_voting ? "Enabled" : "Disabled"}</p>
            <p><strong>Real-time Results:</strong> ${var.enable_realtime_results ? "Enabled" : "Disabled"}</p>
        </div>
        <p>This is a placeholder Team Polls template. Perfect for team surveys, decision making, and collecting feedback.</p>
    </div>
</body>
</html>
EOF
}