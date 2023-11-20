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
     Project     = "devopsloop"
     Function    = "site"
   }
 }
}

# Site resources

module "acm_request_certificate" {
  source = "cloudposse/acm-request-certificate/aws"
  version = "0.16.3"
  
  domain_name                       = "devopsloop.in"
  subject_alternative_names         = ["www.devopsloop.in", "dev.devopsloop.in"]
  process_domain_validation_options = true
  ttl                               = "300"
}

module "devopsloop-cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.92.0"

  namespace               = "site"
  stage                   = "prod"
  name                    = "devopsloop-site"
  aliases                 = ["devopsloop.in","www.devopsloop.in"]
  dns_alias_enabled       = true
  parent_zone_name        = "devopsloop.in"
  website_enabled         = true
  allow_ssl_requests_only = false
  acm_certificate_arn     = module.acm_request_certificate.arn

}
