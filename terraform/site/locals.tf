locals {
  #tflint-ignore: terraform_deprecated_interpolation
  subject_alternative_names = var.subject_alternative_names == null ? ["${format("%s%s", "www.", var.site_domain)}", "${format("%s%s", "dev.", var.site_domain)}"] : var.subject_alternative_names
  #tflint-ignore: terraform_deprecated_interpolation
  aliases = var.aliases == null ? ["${format("%s%s", "www.", var.site_domain)}", var.site_domain] : var.aliases

  ssm_parameter_prefix = upper(var.project_name)
  ssm_parameters = {
    "${local.ssm_parameter_prefix}_ACM_CERT_ARN"                = module.acm_request_certificate.arn
    "${local.ssm_parameter_prefix}_S3_BUCKET_DOMAIN"            = module.site_cdn.s3_bucket_domain_name
    "${local.ssm_parameter_prefix}_S3_BUCKET_ARN"               = module.site_cdn.s3_bucket_arn
    "${local.ssm_parameter_prefix}_CLOUDFRONT_DISTRIBUTION_ID"  = module.site_cdn.cf_id
    "${local.ssm_parameter_prefix}_CLOUDFRONT_DISTRIBUTION_ARN" = module.site_cdn.cf_arn
  }
}
