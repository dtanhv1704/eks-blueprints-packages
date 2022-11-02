# K8s Add-on
variable "cluster_name" {
  type = string
}

module "eks_blueprints_kubernetes_addons" {
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  eks_cluster_id = var.cluster_name

  enable_grafana    = true
  enable_prometheus = true
  grafana_helm_config = {
    name        = "grafana"
    chart       = "grafana"
    repository  = "https://grafana.github.io/helm-charts"
    version     = "6.32.1"
    namespace   = "grafana"
    description = "Grafana Helm Chart deployment configuration"
    values      = [templatefile("${path.module}/helm/grafana.yaml", {})]
    set_sensitive = [
      {
        name  = "adminPassword"
        value = "123qweA@"
      }
    ]
  }
}
