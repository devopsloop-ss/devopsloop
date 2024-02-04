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
      Project  = "devopsloop"
      Function = "site"
    }
  }
}

# OIDC provider GitHub

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "5.34.0"

  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}

# IAM Roles GitHub

## data sources to fetch the relevant IDs and ARNs for this site
data "aws_ssm_parameter" "distribution_arn" {
  name = local.site_cloudfront_distribution_arn_parameter_name
}

data "aws_ssm_parameter" "bucket_arn" {
  name = local.site_s3_bucket_arn_parameter_name
}

## IAM policy with granular permissions specific to site deployment
data "aws_iam_policy_document" "github_actions_cloudfront_site" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
    ]

    resources = [
      data.aws_ssm_parameter.bucket_arn.value,
      "${data.aws_ssm_parameter.bucket_arn.value}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetInvalidation",
      "cloudfront:ListDistributions",
      "cloudfront:UpdateDistribution",
    ]

    resources = [
      data.aws_ssm_parameter.distribution_arn.value,
    ]
  }

  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_cloudfront_site" {
  name        = "${var.project_name}-site-deploy-policy"
  description = "IAM policy to allow deploying static site for this project."

  policy = data.aws_iam_policy_document.github_actions_cloudfront_site.json

  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}

## IAM role that allows access only from this repo
module "iam_github_oidc_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "5.34.0"

  subjects = ["devopsloop-ss/devopsloop:*"]

  policies = {
    #tflint-ignore: terraform_deprecated_interpolation
    "${aws_iam_policy.github_actions_cloudfront_site.name}" = "${aws_iam_policy.github_actions_cloudfront_site.arn}"
  }

  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}
