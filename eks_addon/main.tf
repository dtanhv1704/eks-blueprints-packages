# K8s Add-on



module "k8s_eks_addon" {
  source       = "./k8s_eks"
  cluster_name = local.cluster_name
}

module "k8s_ingress" {
  source       = "./k8s_network"
  cluster_name = local.cluster_name
}

module "k8s_scaling_addon" {
  source          = "./k8s_scaling"
  cluster_name    = local.cluster_name
  template_name   = "${local.cluster_name}-${var.eks.nodegroup.name}"
  subnet_selector = "*private*"
}

module "k8s_observability_addon" {
  source       = "./k8s_observability"
  cluster_name = local.cluster_name
}

module "k8s_aws_managed_observability" {
  source       = "./k8s_aws_observability"
  cluster_name = local.cluster_name
  region       = var.region
}

module "k8s_argo_cd" {
  source       = "./k8s_argo_cd"
  cluster_id = local.cluster_name
  enable_argocd = var.enable_argocd

  oidc_client_secret = var.argocd_config.oidc_client_secret
  oidc_client_id = var.argocd_config.oidc_client_id
  oidc_issuer_url = var.argocd_config.oidc_issuer_url
  cognito_domain = var.argocd_config.cognito_domain
  argocd_ui_url = var.argocd_config.argocd_ui_url
  argocd_url_acm_arn = var.argocd_config.argocd_url_acm_arn
}
