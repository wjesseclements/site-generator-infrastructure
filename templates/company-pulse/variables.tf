variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
}

variable "site_name" {
  description = "Name of the Company Pulse site"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "company_name" {
  description = "Name of the company"
  type        = string
  default     = "My Company"
}

variable "enable_analytics" {
  description = "Enable analytics tracking"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}