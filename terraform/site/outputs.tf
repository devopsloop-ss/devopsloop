output "acm_certificate_arn" {
  value       = module.acm_request_certificate.arn
  description = "ARN of the ACM certificate generated for this site"
}

output "s3_bucket_domain_name" {
  value       = module.site_cdn.s3_bucket_domain_name
  description = "Domain name of the s3 bucket for this site"
}

output "s3_bucket_arn" {
  value       = module.site_cdn.s3_bucket_arn
  description = "ARN of the S3 bucket for the site"
}

output "cloudfront_distribution_id" {
  value       = module.site_cdn.cf_id
  description = "ID of the cloudfront distribution for the site"
}

output "cloudfront_distribution_arn" {
  value       = module.site_cdn.cf_arn
  description = "ARN for the cloudfront distribution for the site"
}
