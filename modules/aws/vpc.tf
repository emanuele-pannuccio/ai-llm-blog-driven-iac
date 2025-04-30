data "aws_availability_zones" "available_zones" {}

resource "aws_ec2_instance_connect_endpoint" "aws-ec2-instance-endpoint" {
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [module.bastion-host-sg.security_group_id]
}

module "aws-ec2-instance-endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.bastion-host-sg.security_group_id]

  endpoints = {
    ssm = {
      # interface endpoint
      service             = "ssm"
      tags                = { Name = "ssm-vpc-endpoint" }
      subnet_ids          = module.vpc.private_subnets
      private_dns_enabled = true

    }
    ssmmessages = {
      # interface endpoint
      service             = "ssmmessages"
      tags                = { Name = "ssmmessages-vpc-endpoint" }
      subnet_ids          = module.vpc.private_subnets
      private_dns_enabled = true
    }
    ec2messages = {
      # interface endpoint
      service             = "ec2messages"
      tags                = { Name = "ec2messages-vpc-endpoint" }
      subnet_ids          = module.vpc.private_subnets
      private_dns_enabled = true
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.20.0"

  name = "${var.prefix}-vpc"

  cidr = "10.0.0.0/16"

  azs = data.aws_availability_zones.available_zones.names

  private_subnets  = ["10.0.0.0/28", "10.0.0.48/28"]
  database_subnets = ["10.0.0.16/28", "10.0.0.32/28"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}
