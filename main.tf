# -------------------------------------------------------------------------
# ROOT MODULE: Orchestration Layer
# -------------------------------------------------------------------------

# 1. Network Fabric
module "network_fabric" {
  source = "./modules/network"

  namespace          = var.namespace
  stage              = var.stage
  name               = "vpc"
  cidr_block         = var.vpc_cidr_block
  availability_zones = var.availability_zones
  tags               = local.tags
}

# 2. Ingress Traffic (ALB + Security Groups)
module "ingress_traffic" {
  source = "./modules/traffic"

  namespace       = var.namespace
  stage           = var.stage
  name            = "ingress"
  vpc_id          = module.network_fabric.vpc_id
  public_subnets  = module.network_fabric.public_subnet_ids
  container_port  = var.container_port
  tags            = local.tags
}

# 3. Identity & Permissions
module "iam_identity" {
  source = "./modules/identity"

  namespace = var.namespace
  stage     = var.stage
  name      = "ecs-exec"
  tags      = local.tags
}

# 4. Compute Layer (Fargate)
module "compute_cluster" {
  source = "./modules/compute"

  namespace          = var.namespace
  stage              = var.stage
  name               = "workload"
  vpc_id             = module.network_fabric.vpc_id
  private_subnets    = module.network_fabric.private_subnet_ids
  security_groups    = [module.ingress_traffic.ecs_security_group_id]
  target_group_arn   = module.ingress_traffic.target_group_arn
  execution_role_arn = module.iam_identity.execution_role_arn
  
  # App Specs
  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.fargate_cpu
  memory             = var.fargate_memory
  
  tags               = local.tags
}