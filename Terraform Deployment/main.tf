module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone
  environment        = var.environment
}

module "security" {
  source = "./modules/security"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  my_ip       = var.my_ip
}

module "compute" {
  source = "./modules/compute"

  ami_id               = var.ami_id
  key_name            = var.key_name
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  web_security_group_id = module.security.web_security_group_id
  db_security_group_id  = module.security.database_security_group_id
  instance_profile_name = module.security.instance_profile_name
  environment         = var.environment
}