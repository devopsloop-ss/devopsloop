# Terraform IaC for devopsloop site on AWS

## Overview

The IaC in this repo deploys the necessary infra for devopsloop to AWS

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_request_certificate"></a> [acm\_request\_certificate](#module\_acm\_request\_certificate) | cloudposse/acm-request-certificate/aws | 0.16.3 |
| <a name="module_site_cdn"></a> [site\_cdn](#module\_site\_cdn) | cloudposse/cloudfront-s3-cdn/aws | 0.92.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.site_outputs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [github_actions_environment_secret.env_role_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additonal_origins"></a> [additonal\_origins](#input\_additonal\_origins) | List of additional origins to add to your site. Useful for addind additional pages or sites outside this static site. | <pre>list(object({<br>    domain_name = string<br>    origin_id   = string<br>    origin_path = string<br>    custom_headers = list(object({<br>      name  = string<br>      value = string<br>    }))<br>    custom_origin_config = object({<br>      http_port                = number<br>      https_port               = number<br>      origin_protocol_policy   = string<br>      origin_ssl_protocols     = list(string)<br>      origin_keepalive_timeout = number<br>      origin_read_timeout      = number<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Aliases for the site for CloudFront CDN. If left unchanged, the default values generated are : www.site\_domain, site\_domain | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the target environment | `string` | `"prod"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"devopsloop-site"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of this repo. Used for tagging resources. | `string` | `"devopsloop-ss/devopsloop"` | no |
| <a name="input_site_domain"></a> [site\_domain](#input\_site\_domain) | Doman name of the site | `string` | `"devopsloop.in"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Subject alternative names for the ACM certificate. If left unchanged, the default values generated are : www.site\_domain, dev.site\_domain | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | ARN of the ACM certificate generated for this site |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | ARN for the cloudfront distribution for the site |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | ID of the cloudfront distribution for the site |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket for the site |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | Domain name of the s3 bucket for this site |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
