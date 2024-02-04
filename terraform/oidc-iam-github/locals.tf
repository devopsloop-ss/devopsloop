locals {
  site_s3_bucket_arn_parameter_name               = var.site_s3_bucket_arn_parameter_name == null ? "${upper(var.project_name)}_S3_BUCKET_ARN" : var.site_s3_bucket_arn_parameter_name
  site_cloudfront_distribution_arn_parameter_name = var.site_cloudfront_distribution_arn_parameter_name == null ? "${upper(var.project_name)}_CLOUDFRONT_DISTRIBUTION_ARN" : var.site_cloudfront_distribution_arn_parameter_name
}
