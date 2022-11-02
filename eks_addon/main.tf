# K8s Add-on

# module "eks_blueprint_k8s_network" {
#   source       = "./k8s_network"
#   cluster_name = local.cluster_name
# }

module "eks_blueprint_k8s_eks_addon" {
  source       = "./k8s_eks"
  cluster_name = local.cluster_name
}

module "eks_blueprint_k8s_scaling_addon" {
  source          = "./k8s_scaling"
  cluster_name    = local.cluster_name
  template_name   = "${local.cluster_name}-${var.eks.nodegroup.name}"
  subnet_selector = "*private*"
}

module "eks_blueprint_k8s_observability_addon" {
  source       = "./k8s_observability"
  cluster_name = local.cluster_name
}

module "eks_blueprint_k8s_aws_managed_observability" {
  source       = "./k8s_aws_observability"
  cluster_name = local.cluster_name
  region       = var.region
}



# module "eks_blueprints_kubernetes_addons" {
#   source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
#   eks_cluster_id = local.cluster_name

#   # EKS Addons
#   enable_amazon_eks_vpc_cni    = true
#   enable_amazon_eks_coredns    = true
#   enable_amazon_eks_kube_proxy = true

#   # ingress
#   enable_aws_load_balancer_controller = true

#   enable_ingress_nginx = true
#   ingress_nginx_helm_config = {
#     repository = "https://kubernetes.github.io/ingress-nginx"
#     chart      = "ingress-nginx"
#     namespace  = "nginx-ingress"
#     timeout    = 2000
#     values     = [file("${path.module}/helm/nginx-values.yaml")]
#   }
# }

# resource "kubectl_manifest" "ingress_nodeport" {
#   depends_on = [
#     module.eks_blueprints_kubernetes_addons
#   ]
#   yaml_body = file("${path.module}/manifest/ingress-nodeport.yaml")
# }



# module "managed_grafana" {
#   source = "terraform-aws-modules/managed-service-grafana/aws"

#   name                     = "tf-eks-grafana"
#   description              = "AWS Managed Grafana service tf-eks-blueprints workspace"
#   account_access_type      = "CURRENT_ACCOUNT"
#   authentication_providers = ["AWS_SSO"]
#   permission_type          = "SERVICE_MANAGED"
#   data_sources             = ["PROMETHEUS"]
#   associate_license        = false

#   # Workspace API keys
#   workspace_api_keys = {
#     admin = {
#       key_name        = "admin"
#       key_role        = "ADMIN"
#       seconds_to_live = 432000
#     }
#   }
# }


# module "eks_observability_accelerator" {
#   source = "github.com/aws-observability/terraform-aws-observability-accelerator"
#   # providers = {
#   #   aws = aws.alternate
#   # }
#   aws_region                   = var.region
#   eks_cluster_id               = local.cluster_name
#   enable_managed_grafana       = false
#   managed_grafana_workspace_id = split(".", module.managed_grafana.workspace_endpoint)[0]
#   grafana_api_key              = module.managed_grafana.workspace_api_keys["admin"].key
#   enable_managed_prometheus    = true
# }


