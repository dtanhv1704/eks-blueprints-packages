variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "tenant" {
  type = string
}

variable "eks" {
  type = object({
    private_accessible = bool
    public_accessible  = bool
    cluster_version    = string
    nodegroup = object({
      name                    = string
      desired_size            = number
      max_size                = number
      min_size                = number
      capacity                = string
      instance_types          = list(any)
      encrypted               = bool
      volume_size             = number
      additional_iam_policies = list(string)
      device_name             = string
      volume_type             = string
    })
  })
}


variable "enable_argocd" {
  type = bool
  default = false
}

variable argocd_config {
  type = object({
    oidc_client_secret = string
    oidc_client_id = string
    oidc_issuer_url = string
    cognito_domain = string
    argocd_ui_url = string
    argocd_url_acm_arn = string
  })

  default = {
    argocd_ui_url = "default"
    argocd_url_acm_arn = "default"
    cognito_domain = "default"
    oidc_client_id = "default"
    oidc_client_secret = "default"
    oidc_issuer_url = "default"
  }
}