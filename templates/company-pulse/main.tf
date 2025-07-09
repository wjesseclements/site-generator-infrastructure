terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# S3 bucket for the Company Pulse website
resource "aws_s3_bucket" "company_pulse_site" {
  bucket = "${var.site_name}-company-pulse-${var.deployment_id}"

  tags = merge(var.tags, {
    Name = "${var.site_name} Company Pulse"
    Type = "Website"
  })
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "company_pulse_site" {
  bucket = aws_s3_bucket.company_pulse_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 bucket public access block (disabled for website hosting)
resource "aws_s3_bucket_public_access_block" "company_pulse_site" {
  bucket = aws_s3_bucket.company_pulse_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket policy for public read access
resource "aws_s3_bucket_policy" "company_pulse_site" {
  bucket = aws_s3_bucket.company_pulse_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.company_pulse_site.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.company_pulse_site]
}

# Upload a simple HTML file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.company_pulse_site.id
  key          = "index.html"
  content_type = "text/html"
  
  content = <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${var.site_name} - Company Pulse</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        .status { background: #e8f5e8; padding: 20px; border-radius: 4px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${var.site_name} - Company Pulse</h1>
        <div class="status">
            <h2>✅ Deployment Successful!</h2>
            <p>Your Company Pulse website has been successfully deployed using the Site Generator Platform.</p>
            <p><strong>Deployment ID:</strong> ${var.deployment_id}</p>
            <p><strong>Environment:</strong> ${var.environment}</p>
        </div>
        <p>This is a placeholder Company Pulse template. You can customize this template by modifying the Terraform files in your infrastructure repository.</p>
    </div>
</body>
</html>
EOF
}