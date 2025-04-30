locals {
  gcp_cloud_nat_gw = var.gcp_nat_gateway # Cloud NAT Gateway - GCP
}

module "bastion-host-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${var.prefix}-bastion-sg"

  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow ingress HTTPS traffic from SSM Manager Tunnel"
      cidr_blocks = "10.0.0.0/16"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow all outbound traffic"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow all outbound traffic"
      cidr_blocks = "10.0.0.0/16"
    },
  ]
}

module "bastion-host" {
  source             = "terraform-aws-modules/ec2-instance/aws"
  version            = "5.8.0"
  name               = "${var.prefix}-bastion-host"
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.private_subnets[0]
  ignore_ami_changes = false
  ami                = "ami-0e03e80affb5b6b06"

  vpc_security_group_ids      = [module.bastion-host-sg.security_group_id]
  create_iam_instance_profile = true

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
