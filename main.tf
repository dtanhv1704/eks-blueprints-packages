module "my_vpc" {
  source      = "./vpc"
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  tags        = var.tags
  tenant      = var.tenant
}

module "my_eks" {
  source      = "./eks"
  region      = var.region
  environment = var.environment
  tags        = var.tags
  tenant      = var.tenant
  eks         = var.eks
}

