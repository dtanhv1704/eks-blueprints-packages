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
