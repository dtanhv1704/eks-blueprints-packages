# K8s Add-on
variable "cluster_name" {
  type = string
}

variable "template_name" {
  type = string
}

variable "subnet_selector" {
  type = string
}

module "eks_blueprints_kubernetes_addons" {
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  eks_cluster_id = var.cluster_name

  enable_karpenter = true
  #   enable_cluster_autoscaler = true
}

resource "kubectl_manifest" "karpenter_provisioner" {
  depends_on = [
    module.eks_blueprints_kubernetes_addons
  ]
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
  limits:
    resources:
      cpu: 1000
  provider:
    instanceProfile: ${var.template_name}
    subnetSelector:
        Name: "${var.subnet_selector}"
    securityGroupSelector:
        kubernetes.io/cluster/${var.cluster_name}: owned
    tags:
        Name: karpenter.sh/provisioner/${var.cluster_name}
  ttlSecondsAfterEmpty: 30
  YAML
}
