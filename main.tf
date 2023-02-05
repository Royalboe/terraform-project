module "network" {
  source = "./modules/network"
  namespace = var.namespace
  destination_cidr_block = var.destination_cidr_block
  main_vpc_cidr = var.main_vpc_cidr
  public_subnets = var.public_subnets
  availability_zones = var.availability_zones
}

module "ssh_key" {
  source = "./modules/ssh-key-pair"
  namespace = var.namespace
}

module "servers" {
  source = "./modules/servers"
  key_name = module.ssh_key.key_name
  pub_subnets = module.network.pub_subnets
  web_server_SG = module.network.web_server_SG
  availability_zones = var.availability_zones
  namespace = var.namespace
}

module "loadbalancer" {
  source = "./modules/load-balancer"
  lb_name = "${var.namespace}-lb"
  vpc_id = module.network.vpc_id
  public_subnets = module.network.public_subnets
  web_ids = module.servers.web_ids
  lb_sec_grps = module.network.lb_sec_grps
  namespace = var.namespace
}

module "route53" {
  source = "./modules/route53"
  domain = var.domain
  vpc_id = module.network.vpc_id
  lb_dns_name = module.loadbalancer.lb_dns_name
  alb_zone_id = module.loadbalancer.alb_zone_id
  namespace = var.namespace
}