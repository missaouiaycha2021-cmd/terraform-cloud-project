provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "network" {
  source             = "../../modules/network"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "security" {
  source      = "../../modules/security"
  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
}

#module "storage" {
# source        = "../../modules/storage"
# name_prefix   = local.name_prefix
#bucket_suffix = var.bucket_suffix
#}

module "database" {
  source                = "../../modules/database"
  name_prefix           = local.name_prefix
  private_db_subnet_ids = module.network.private_db_subnet_ids
  db_sg_id              = module.security.db_sg_id
  db_instance_class     = var.db_instance_class
  multi_az              = var.db_multi_az
  master_password       = var.db_password
}

module "load_balancer" {
  source            = "../../modules/load-balancer"
  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

module "compute" {
  source                = "../../modules/compute"
  name_prefix           = local.name_prefix
  private_subnet_ids    = module.network.private_app_subnet_ids
  app_sg_id             = module.security.app_sg_id
  target_group_arn      = module.load_balancer.target_group_arn
  instance_profile_name = module.security.instance_profile_name
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  user_data             = file("${path.module}/../../scripts/user_data.sh")
}