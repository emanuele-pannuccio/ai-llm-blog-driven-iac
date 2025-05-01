data "aws_availability_zones" "available_zones" {}

locals {
  # Calcola quanti bit aggiungere per arrivare a /28
  base_prefix_len = tonumber(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)$", var.vpc.cidr)[0])
  newbits         = 28 - local.base_prefix_len
  private_subnets = {
    "bastion-snet"  = cidrsubnet(var.vpc.cidr, 28 - local.base_prefix_len, 0) # x.x.x.0/28
    "rabbitmq-snet" = cidrsubnet(var.vpc.cidr, 28 - local.base_prefix_len, 1) # x.x.x.16/28 partendo 
  }
  database_subnets = [
    cidrsubnet(var.vpc.cidr, 28 - local.base_prefix_len, 2), # x.x.x.32/28
    cidrsubnet(var.vpc.cidr, 28 - local.base_prefix_len, 3)  # x.x.x.48/28
  ]
}

resource "aws_ec2_instance_connect_endpoint" "aws-ec2-instance-endpoint" {
  subnet_id = module.vpc.private_subnets[0]
  security_group_ids = [
    module.bastion-host-ssm-sg.security_group_id
  ]
}

module "aws-ec2-instance-endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  security_group_ids = [
    module.bastion-host-ssm-sg.security_group_id
  ]

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

  cidr = var.vpc.cidr

  azs = data.aws_availability_zones.available_zones.names

  private_subnets = [
    local.private_subnets["bastion-snet"],
    local.private_subnets["rabbitmq-snet"]
  ]
  database_subnets = local.database_subnets

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}
