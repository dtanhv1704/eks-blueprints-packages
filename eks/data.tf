data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Project"
    values = [var.tags.Project]
  }
  filter {
    name   = "tag:tier"
    values = ["private"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Project"
    values = [var.tags.Project]
  }
  filter {
    name   = "tag:Env"
    values = ["staging"]
  }
}

# EKS Optimized AMI for Worker node
data "aws_ami" "amzn2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks.cluster_version}*"]
  }
  owners = ["amazon"]
}
