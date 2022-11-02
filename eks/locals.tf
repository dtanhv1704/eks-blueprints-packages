locals {
  cluster_name = join("-", [var.tenant, var.environment, "eks"])
}
