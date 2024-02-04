variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "devopsloop-site"
}

variable "environment" {
  type        = string
  description = "Name of the target environment"
  default     = "prod"
}

variable "repo_name" {
  type        = string
  description = "Name of this repo. Used for tagging resources."
  default     = "devopsloop-ss/devopsloop"
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
