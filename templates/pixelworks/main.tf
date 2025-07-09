terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# S3 bucket for the PixelWorks website
resource "aws_s3_bucket" "pixelworks_site" {
  bucket = "${var.site_name}-pixelworks-${var.deployment_id}"

  tags = merge(var.tags, {
    Name = "${var.site_name} PixelWorks"
    Type = "Website"
  })
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "pixelworks_site" {
  bucket = aws_s3_bucket.pixelworks_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 bucket public access block (disabled for website hosting)
resource "aws_s3_bucket_public_access_block" "pixelworks_site" {
  bucket = aws_s3_bucket.pixelworks_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket policy for public read access
resource "aws_s3_bucket_policy" "pixelworks_site" {
  bucket = aws_s3_bucket.pixelworks_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.pixelworks_site.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.pixelworks_site]
}

# Upload a simple HTML file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.pixelworks_site.id
  key          = "index.html"
  content_type = "text/html"
  
  content = <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${var.site_name} - PixelWorks</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { max-width: 800px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 40px; border-radius: 15px; backdrop-filter: blur(10px); }
        h1 { color: #fff; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .status { background: rgba(255,255,255,0.2); padding: 20px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${var.site_name} - PixelWorks</h1>
        <div class="status">
            <h2>🎨 Deployment Successful!</h2>
            <p>Your PixelWorks creative portfolio has been successfully deployed using the Site Generator Platform.</p>
            <p><strong>Deployment ID:</strong> ${var.deployment_id}</p>
            <p><strong>Environment:</strong> ${var.environment}</p>
            <p><strong>Theme:</strong> ${var.theme}</p>
        </div>
        <p>This is a placeholder PixelWorks template. Perfect for creative portfolios, design showcases, and artistic presentations.</p>
    </div>
</body>
</html>
EOF
}