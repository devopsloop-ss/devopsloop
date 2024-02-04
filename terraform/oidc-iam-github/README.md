# Terraform IaC for devopsloop site on AWS

## Overview

The IaC in this repo deploys the necessary IAM resources for CI/CD automation in this repo

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.35.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_github_oidc_provider"></a> [iam\_github\_oidc\_provider](#module\_iam\_github\_oidc\_provider) | terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider | 5.34.0 |
| <a name="module_iam_github_oidc_role"></a> [iam\_github\_oidc\_role](#module\_iam\_github\_oidc\_role) | terraform-aws-modules/iam/aws//modules/iam-github-oidc-role | 5.34.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.github_actions_cloudfront_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [github_actions_environment_secret.env_role_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [aws_iam_policy_document.github_actions_cloudfront_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.bucket_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.distribution_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the target environment | `string` | `"prod"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"devopsloop-site"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of this repo. Used for tagging resources. | `string` | `"devopsloop-ss/devopsloop"` | no |
| <a name="input_site_cloudfront_distribution_arn_parameter_name"></a> [site\_cloudfront\_distribution\_arn\_parameter\_name](#input\_site\_cloudfront\_distribution\_arn\_parameter\_name) | Name of the SSM parameter to fetch the site cloudfront distribution | `string` | `null` | no |
| <a name="input_site_s3_bucket_arn_parameter_name"></a> [site\_s3\_bucket\_arn\_parameter\_name](#input\_site\_s3\_bucket\_arn\_parameter\_name) | Name of the SSM parameter to fetch the site s3 bucket ARN | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_role_arn"></a> [oidc\_role\_arn](#output\_oidc\_role\_arn) | IAM OIDC Role ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
