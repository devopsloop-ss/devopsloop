
variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "devopsloop-site"
}

variable "environment" {
  type        = string
  description = "Name of the target environment"
  default     = "prod"
}

variable "repo_name" {
  type        = string
  description = "Name of this repo. Used for tagging resources."
  default     = "devopsloop-ss/devopsloop"
}

variable "site_domain" {
  type        = string
  description = "Doman name of the site"
  default     = "devopsloop.in"
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "Subject alternative names for the ACM certificate. If left unchanged, the default values generated are : www.site_domain, dev.site_domain"
  default     = null
}

variable "aliases" {
  type        = list(string)
  description = "Aliases for the site for CloudFront CDN. If left unchanged, the default values generated are : www.site_domain, site_domain"
  default     = null
}

variable "additonal_origins" {
  type = list(object({
    domain_name = string
    origin_id   = string
    origin_path = string
    custom_headers = list(object({
      name  = string
      value = string
    }))
    custom_origin_config = object({
      http_port                = number
      https_port               = number
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = number
      origin_read_timeout      = number
    })
  }))
  default     = []
  description = "List of additional origins to add to your site. Useful for addind additional pages or sites outside this static site."
}
