data "external" "get_cluster_role_existed" {
  program = ["sh", "./scripts/check-cluster-role.sh"]
  query = {
    role_name = "${local.cluster_name}-cluster-role"
  }
}

data "external" "get_nodegroup_role_existed" {
  program = ["sh", "./scripts/check-nodegroup-role.sh"]
  query = {
    role_name = "${local.cluster_name}-${var.eks.nodegroup.name}"
  }
}

data "external" "get_kms_existed" {
  program = ["sh", "./scripts/check-cluster-kms.sh"]
  query = {
    key_alias = "alias/${local.cluster_name}"
  }
}


data "external" "k8s_get_nodes" {
  program = ["sh", "./scripts/k8s-get-nodes.sh"]
  query = {
    cluster_name = "${local.cluster_name}"
  }
}

module "eks" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints"

  # EKS CLUSTER
  vpc_id                          = data.aws_vpc.vpc.id
  private_subnet_ids              = data.aws_subnets.private_subnets.ids
  cluster_kms_key_arn             = data.external.get_kms_existed.result.arn
  cluster_endpoint_private_access = var.eks.private_accessible
  cluster_endpoint_public_access  = var.eks.public_accessible
  cluster_name                    = local.cluster_name
  cluster_version                 = var.eks.cluster_version
  tags                            = var.tags
  create_iam_role                 = !tobool(data.external.get_cluster_role_existed.result.exist)
  iam_role_arn                    = tobool(data.external.get_cluster_role_existed.result.exist) ? data.external.get_cluster_role_existed.result.arn : null


  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mt_3 = {
      node_group_name         = var.eks.nodegroup.name
      subnet_ids              = data.aws_subnets.private_subnets.ids
      desired_size            = var.eks.nodegroup.desired_size
      max_size                = var.eks.nodegroup.max_size
      min_size                = var.eks.nodegroup.min_size
      capacity_type           = var.eks.nodegroup.capacity
      create_iam_role         = !tobool(data.external.get_nodegroup_role_existed.result.exist)
      iam_role_arn            = tobool(data.external.get_nodegroup_role_existed.result.exist) ? data.external.get_nodegroup_role_existed.result.arn : null
      instance_types          = var.eks.nodegroup.instance_types
      additional_iam_policies = var.eks.nodegroup.additional_iam_policies
      kubelet_extra_args      = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
      create_launch_template  = true

      block_device_mappings = [
        {
          device_name = var.eks.nodegroup.device_name
          volume_type = var.eks.nodegroup.volume_type
          volume_size = var.eks.nodegroup.volume_size
          encrypted   = var.eks.nodegroup.encrypted
        }
      ]
      additional_tags = var.tags
    }
  }
}
