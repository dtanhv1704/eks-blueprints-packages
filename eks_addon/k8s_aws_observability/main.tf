# K8s Add-on
variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

module "eks_observability_accelerator" {
  source                       = "github.com/aws-observability/terraform-aws-observability-accelerator"
  aws_region                   = var.region
  eks_cluster_id               = var.cluster_name
  enable_managed_prometheus    = true
  enable_managed_grafana       = false
  managed_grafana_workspace_id = split(".", module.managed_grafana.workspace_endpoint)[0]
  grafana_api_key              = module.managed_grafana.workspace_api_keys["admin"].key
}

module "managed_grafana" {
  source = "terraform-aws-modules/managed-service-grafana/aws"

  name                     = "aws-observability-accelerator"
  description              = "AWS Managed Grafana service aws-observability-accelerator workspace"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["PROMETHEUS"]
  associate_license        = false

  # Workspace API keys
  workspace_api_keys = {
    admin = {
      key_name        = "admin"
      key_role        = "ADMIN"
      seconds_to_live = 432000
    }
  }
}

module "eks_blueprints_kubernetes_addons" {
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  eks_cluster_id = var.cluster_name

  enable_amazon_prometheus             = true
  enable_prometheus                    = true
  amazon_prometheus_workspace_endpoint = module.eks_observability_accelerator.managed_prometheus_workspace_endpoint
}
