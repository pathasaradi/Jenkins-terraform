provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "../../modules/vpc"
  name            = var.name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "sg" {
  source   = "../../modules/security_groups"
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
}

module "alb" {
  source        = "../../modules/alb"
  name          = "${var.name}-alb"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.public_subnet_ids
  alb_sg_id     = module.sg.alb_sg_id
  app_port      = var.app_port
}

module "ec2_asg" {
  source           = "../../modules/ec2_asg"
  name             = "${var.name}-app"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_ids       = module.vpc.private_subnet_ids
  ec2_sg_id        = module.sg.ec2_sg_id
  target_group_arn = module.alb.target_group_arn
  app_port         = var.app_port
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
}

output "vpc_id"   { value = module.vpc.vpc_id }
output "alb_dns"  { value = module.alb.alb_dns_name }
output "asg_name" { value = module.ec2_asg.asg_name }
