output "oidc_role_arn" {
  value       = module.iam_github_oidc_role.arn
  description = "IAM OIDC Role ARN"
}
