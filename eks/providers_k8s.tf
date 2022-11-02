provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "external" "get_eks_cluster" {
  program = ["sh", "./scripts/check-cluster.sh"]
  query = {
    cluster_name = "${local.cluster_name}"
  }
}

data "aws_eks_cluster" "this" {
  name = tobool(data.external.get_eks_cluster.result.exist) ? local.cluster_name : module.eks.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = tobool(data.external.get_eks_cluster.result.exist) ? local.cluster_name : module.eks.eks_cluster_id
}

# provider "kubernetes" {
#   host                   = module.eks.eks_cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.eks_cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.this.token
#   }
# }

# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.eks_cluster_id
# }


