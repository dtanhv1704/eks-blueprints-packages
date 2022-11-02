variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(any)
}


variable "tenant" {
  type = string
}

variable "eks" {
  type = object({
    private_accessible = bool
    public_accessible  = bool
    cluster_version    = string
    nodegroup = object({
      name           = string
      desired_size   = number
      max_size       = number
      min_size       = number
      capacity       = string
      instance_types = list(any)
      encrypted      = bool
      volume_size    = number
    })
  })
}
