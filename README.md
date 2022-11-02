# EKS Blueprints with Terraform

Welcome to the EKS Blueprints with addons package for Terraform.

The EKS Blueprints with Terraform is a set of modules th help you provisioning EKS cluster with Kubernetes Addons. This project proposes a core module to bootstrap cluster with AWS sources (VPC, AWS Managed Prometheus, AWS Managed Grafana) and other third party (Nginx, Karpenter, Prometheus, Grafana, ...)

# Getting started

### 1. Create VPC
```bash
$ cd vpc
$ terraform init -backend-config="bucket=xxx" \
        -backend-config="key=vpc" \
        -backend-config="region=xxx"
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars
$ terraform apply plan_file
```

### 2. Create EKS Cluster
```bash
$ cd eks
$ terraform init -backend-config="bucket=xxx" \
        -backend-config="key=eks" \
        -backend-config="region=xxx"
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars
$ terraform apply plan_file
```

### 3. Create EKS Addons

```bash
$ cd eks
$ terraform init -backend-config="bucket=xxx" \
        -backend-config="key=eks" \
        -backend-config="region=xxx"
```

#### 3.1 Add EKS basic addons
```
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars -target=module.k8s_eks_addon
$ terraform apply plan_file
```


#### 3.2 Add Nginx Ingress
```
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars -target=module.k8s_ingress
$ terraform apply plan_file
```

#### 3.3 Add Karpenter & Provisioner
```
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars -target=module.k8s_scaling_addon
$ terraform apply plan_file
```

#### 3.4 Add Self-managed Prometheus + Grafana
```
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars -target=module.k8s_observability_addon
$ terraform apply plan_file
```

#### 3.5 Add AWS Managed Prometheus + Grafana
```
$ terraform plan -out=plan_file -var-file=../vars/terraform.tfvars -target=module.k8s_aws_managed_observability
$ terraform apply plan_file
```
