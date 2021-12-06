data "aws_ami" "amazon2" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
module "ec2_app" {
   source = "./modules/ec2"
 
   infra_env = var.infra_env
   infra_role = "app"
   instance_size = "t3.small"
   instance_ami = data.aws_ami.amazon2.id
   # instance_root_device_size = 12 # Optional
   subnets = keys(module.vpc.vpc_public_subnets) # Note: Public subnets 
  # security_groups = [] # TODO: Create security groups
  # security_groups = [module.vpc.security_group_public] 
  # instance_root_device_size = 12 
}
 
module "ec2_worker" {
   source = "./modules/ec2"
   infra_env = var.infra_env
   infra_role = "worker"
   instance_size = "t3.large"
   instance_ami = data.aws_ami.amazon2.id
   instance_root_device_size = 50
   subnets = keys(module.vpc.vpc_private_subnets) # Note: Private subnets  
  # security_groups = [module.vpc.security_group_public] 
  # security_groups = [] # TODO: Create security groups
  # instance_root_device_size = 20 // 
}

module "vpc" {
  source = "./modules/vpc"
 
  infra_env = var.infra_env
  vpc_cidr  = "10.0.0.0/16"
}

resource "aws_eip" "nat" {
  count = 2

  vpc = true
}