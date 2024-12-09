provider "aws" {
  region  = var.region
 
}

module "vpc" {
  source                  = "../modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
}


module "nat_gatway" {
  source                = "../modules/ngw"
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  internet_gateway_id   = module.vpc.internet_gateway_id
  vpc_id                = module.vpc.vpc_id
  private_subnet_az1_id = module.vpc.private_subnet_az1_id
  private_subnet_az2_id = module.vpc.private_subnet_az2_id


}

module "security_group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "app_load_balancer" {
  source               = "../modules/elb"
  project_name         = module.vpc.project_name
  lb_security_group_id = module.security_group.lb_security_group_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id               = module.vpc.vpc_id
}
module "ec2" {
  source = "../modules/ec2"

  ami                    = var.ami
  project_name           = module.vpc.project_name
  public_subnet_az1_id   = module.vpc.public_subnet_az1_id
  public_subnet_az2_id   = module.vpc.public_subnet_az2_id
  private_subnet_az1_id  = module.vpc.private_subnet_az1_id
  private_subnet_az2_id  = module.vpc.private_subnet_az2_id
  pub_security_group_id  = module.security_group.pub_security_group_id
  priv_security_group_id = module.security_group.priv_security_group_id
}

output "ec2_public_ip_az1_from_module" {
  value = module.ec2.ec2_public_ip_az1

  
}

output "ec2_public_ip_az2_from_module" {
  value = module.ec2.ec2_public_ip_az2
  
}

output "ec2_private_ip_az1_from_module" {
  value = module.ec2.ec2_private_ip_az1
  
}

output "ec2_private_ip_az2_from_module" {
  value = module.ec2.ec2_private_ip_az2
  
}

output "private_key" {
  value = module.ec2.private_key_pem
  sensitive = true
}

output "public_key" {
  value = module.ec2.public_key
}