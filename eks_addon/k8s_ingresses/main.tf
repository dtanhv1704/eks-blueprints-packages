# K8s Add-on
variable "cluster_name" {
  type = string
}

module "eks_blueprints_kubernetes_addons" {
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  eks_cluster_id = var.cluster_name

  # ingress
  enable_aws_load_balancer_controller = true

  enable_ingress_nginx = true
  ingress_nginx_helm_config = {
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart      = "ingress-nginx"
    namespace  = "nginx-ingress"
    timeout    = 2000
    values     = [file("${path.cwd}/helm/nginx-values.yaml")]
  }
}
