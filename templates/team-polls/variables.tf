variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
}

variable "site_name" {
  description = "Name of the Team Polls site"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "max_options_per_poll" {
  description = "Maximum number of options allowed per poll"
  type        = number
  default     = 10
}

variable "enable_anonymous_voting" {
  description = "Allow anonymous voting"
  type        = bool
  default     = true
}

variable "enable_realtime_results" {
  description = "Show real-time voting results"
  type        = bool
  default     = true
}

variable "poll_duration_days" {
  description = "Default poll duration in days"
  type        = number
  default     = 7
}

variable "enable_comments" {
  description = "Enable comments on polls"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}