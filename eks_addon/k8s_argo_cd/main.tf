variable "cluster_id" {
  type = string
}

variable "oidc_client_secret" {
  type = string
}

variable "oidc_client_id" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "cognito_domain" {
  type = string
}

variable "argocd_ui_url" {
  type = string
}

variable "argocd_url_acm_arn" {
  type = string
}

variable "enable_argocd" {
  type = bool
}

# K8s Add-on
module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.12.1"

  count = var.enable_argocd ? 1 : 0
  eks_cluster_id = var.cluster_id

  #K8s Add-ons
  enable_aws_load_balancer_controller = true
  # enable_external_secrets             = true
  enable_argocd                       = var.enable_argocd

  argocd_helm_config = {
    repository  = "https://argoproj.github.io/argo-helm"
    chart       = "argo-cd"
    namespace   = "argocd"
    version     = "v5.6.6"
    timeout     = "1200"
    values      = [templatefile("${path.module}/argocd-helm-config.yaml", {
      oidc_client_secret = var.oidc_client_secret,
      oidc_client_id = var.oidc_client_id,
      oidc_issuer_url = var.oidc_issuer_url,
      cognito_domain = var.cognito_domain,
      argocd_ui_url = var.argocd_ui_url,
      argocd_url_acm_arn = var.argocd_url_acm_arn
    })]
  }
}