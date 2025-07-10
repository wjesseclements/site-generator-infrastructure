# Variables for Test Template

variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
}

variable "site_name" {
  description = "Name of the site to deploy"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.site_name))
    error_message = "Site name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Optional parameters that can be passed from the platform
variable "parameters" {
  description = "Additional template-specific parameters"
  type        = map(any)
  default     = {}
}