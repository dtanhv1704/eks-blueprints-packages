region      = "us-east-1"
tenant      = "tf-eks"
environment = "staging"
tags = {
  "Project" = "tf-eks-blueprints"
  "Env"     = "staging"
}

vpc_cidr = "172.10.0.0/16"

eks = {
  private_accessible = false
  public_accessible  = true
  cluster_version    = "1.22"
  nodegroup = {
    name                    = "ngroup"
    desired_size            = 2
    max_size                = 10
    min_size                = 2
    capacity                = "SPOT"
    instance_types          = ["t3.medium"]
    encrypted               = true
    volume_size             = 40
    additional_iam_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    device_name             = "/dev/xvda"
    volume_type             = "gp3"
  }
}
