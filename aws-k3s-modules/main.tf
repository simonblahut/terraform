# --- root/main.tf ---

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_engine_version      = "8.0.32"
  db_instance_class      = "db.t3.micro"
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.vpc_private_security_group_ids
  db_identifier          = "my-db"
  skip_final_snapshot    = true
}

module "loadbalancing" {
  source                 = "./loadbalancing"
  lb_public_sg           = module.networking.vpc_public_security_group_ids
  lb_public_subnets      = module.networking.lb_public_subnets
  tg_port                = 8000
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "compute" {
  source              = "./compute"
  instance_count      = 2
  instance_type       = "t3.micro"
  public_sg           = module.networking.vpc_public_security_group_ids
  public_subnets      = module.networking.lb_public_subnets
  vol_size            = 10
  key_name            = "my_key"
  user_data_path      = "${path.root}/userdata.tpl"
  db_endpoint         = module.database.db_endpoint
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  lb_target_group_arn = module.loadbalancing.tg_arn
  tg_port             = 8000
}