# K8s Add-on
variable "cluster_name" {
  type = string
}

module "eks_blueprints_kubernetes_addons" {
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  eks_cluster_id = var.cluster_name

  #   # EKS Addons
  enable_amazon_eks_vpc_cni    = true
  enable_amazon_eks_coredns    = true
  enable_amazon_eks_kube_proxy = true

}
