# Common terraform config
terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project  = var.project_name
      Function = "site"
    }
  }
}

# Site resources

module "acm_request_certificate" {
  source = "cloudposse/acm-request-certificate/aws"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "0.16.3"

  domain_name                       = var.site_domain
  subject_alternative_names         = local.subject_alternative_names
  process_domain_validation_options = true
  ttl                               = "300"
}

module "site_cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "0.92.0"

  namespace               = "site"
  stage                   = "prod"
  name                    = var.project_name
  aliases                 = local.aliases
  dns_alias_enabled       = true
  parent_zone_name        = var.site_domain
  website_enabled         = true
  allow_ssl_requests_only = false
  acm_certificate_arn     = module.acm_request_certificate.arn

  custom_origins = var.additonal_origins

}

moved {
  from = module.devopsloop-cdn
  to   = module.site_cdn
}

resource "aws_ssm_parameter" "site_outputs" {
  #checkov:skip=CKV_AWS_337: The parameter stores non sensitive values (recourse ids of cloud resources). KMS Encryption is not needed for this use case.
  for_each = local.ssm_parameters

  name  = each.key
  type  = "String"
  value = each.value

  tags = {
    Environment = "prod"
  }
}
