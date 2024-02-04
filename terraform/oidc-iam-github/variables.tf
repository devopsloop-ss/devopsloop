variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "devopsloop-site"
}

variable "site_cloudfront_distribution_arn_parameter_name" {
  type        = string
  description = "Name of the SSM parameter to fetch the site cloudfront distribution"
  default     = null
}

variable "site_s3_bucket_arn_parameter_name" {
  type        = string
  description = "Name of the SSM parameter to fetch the site s3 bucket ARN"
  default     = null
}
