# Common terraform config
terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = var.project_name
      Function    = "site"
      Environment = var.environment
      repo        = var.repo_name
      path        = "terraform/oidc-iam-github"
    }
  }
}

provider "github" {}

# OIDC provider GitHub

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "5.34.0"
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
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging"
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
}

resource "aws_iam_policy" "github_actions_cloudfront_site" {
  name        = "${var.project_name}-site-deploy-policy"
  description = "IAM policy to allow deploying static site for this project."

  policy = data.aws_iam_policy_document.github_actions_cloudfront_site.json

}

## IAM role that allows access only from this repo
module "iam_github_oidc_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  #checkov:skip=CKV_TF_1: This is a module with reliable versioning control. Terraform registry versioning is adequate.
  version = "5.34.0"

  name = "${var.project_name}-github"

  subjects = ["devopsloop-ss/devopsloop:environment:${var.environment}*"]

  policies = {
    #tflint-ignore: terraform_deprecated_interpolation
    "${aws_iam_policy.github_actions_cloudfront_site.name}" = "${aws_iam_policy.github_actions_cloudfront_site.arn}"
  }

}

# Rendering outputs
resource "aws_ssm_parameter" "site_outputs" {
  #checkov:skip=CKV_AWS_337: The parameter stores non sensitive values (recourse ids of cloud resources). KMS Encryption is not needed for this use case.
  for_each = local.ssm_parameters

  name  = each.key
  type  = "String"
  value = each.value

}

resource "github_actions_environment_secret" "env_role_secret" {
  repository      = basename(var.repo_name)
  environment     = var.environment
  secret_name     = "AWS_DEPLOY_ROLE_ARN"
  plaintext_value = module.iam_github_oidc_role.arn
}
