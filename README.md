# Site Generator Infrastructure Repository

This repository contains Terraform templates and GitHub Actions workflows for deploying website infrastructure via the Site Generator Platform.

## Repository Structure

```
.github/
  workflows/
    deploy-infrastructure.yml    # Main deployment workflow
templates/
  data-explorer/              # Data Explorer template
    main.tf
    variables.tf
    outputs.tf
  company-pulse/              # Company Pulse template
    main.tf
    variables.tf
    outputs.tf
  pixelworks/                 # PixelWorks template
    main.tf
    variables.tf
    outputs.tf
  team-polls/                 # Team Polls template
    main.tf
    variables.tf
    outputs.tf
```

## Setup Instructions

### 1. Configure GitHub OIDC Provider

In your main Site Generator infrastructure (not this repo), add the OIDC provider:

```hcl
# Add to infrastructure/iam.tf
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

resource "aws_iam_role" "github_actions" {
  name = "${local.resource_prefix}-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:wjesseclements/site-generator-infrastructure:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

### 2. Configure Repository Secrets

Add these secrets to this repository (Settings > Secrets and variables > Actions):

- `AWS_ROLE_ARN`: `arn:aws:iam::YOUR_ACCOUNT:role/site-generator-dev-github-actions`
- `WEBHOOK_SECRET`: Same value as in your terraform.tfvars
- `TERRAFORM_STATE_BUCKET`: Your S3 bucket name for Terraform state
- `TERRAFORM_LOCKS_TABLE`: Your DynamoDB table name for locks

### 3. Template Development

Each template should follow this structure:

#### variables.tf
```hcl
variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
}

variable "site_name" {
  description = "Name of the site"
  type        = string
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# Template-specific variables here
```

#### outputs.tf
```hcl
output "website_url" {
  description = "URL of the deployed website"
  value       = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = aws_cloudfront_distribution.main.domain_name
}

# Additional template-specific outputs
```

## Security Features

- **OIDC Authentication**: No long-lived AWS credentials
- **Webhook Verification**: All webhook payloads are HMAC-signed
- **Least Privilege**: Templates only access required resources
- **State Isolation**: Each deployment has isolated Terraform state

## Monitoring

All deployments are logged and can be monitored through:
- GitHub Actions workflow runs
- AWS CloudWatch (Step Functions execution logs)
- Site Generator Platform WebSocket updates

## Support

For issues with templates or deployment processes, check:
1. GitHub Actions workflow logs
2. AWS CloudWatch logs for the deployment
3. Site Generator Platform deployment status