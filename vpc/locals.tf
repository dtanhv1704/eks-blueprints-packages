locals {
  vpc_name      = join("-", [var.tenant, var.environment, "vpc"])
  cluster_name  = join("-", [var.tenant, var.environment, "eks"])
  vpc_state_key = join("-", [var.tenant, var.environment, "vpc"])
}
