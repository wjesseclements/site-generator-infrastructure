variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
}

variable "site_name" {
  description = "Name of the PixelWorks site"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "theme" {
  description = "Visual theme for the portfolio"
  type        = string
  default     = "modern"
}

variable "enable_gallery" {
  description = "Enable image gallery functionality"
  type        = bool
  default     = true
}

variable "max_upload_size" {
  description = "Maximum file upload size in MB"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}