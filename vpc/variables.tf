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
