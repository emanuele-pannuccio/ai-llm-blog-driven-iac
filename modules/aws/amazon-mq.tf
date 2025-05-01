module "rabbitmq-broker-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${var.prefix}-rabbitmq-broker-sg"

  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow ingress GUI RabbitMQ traffic"
      cidr_blocks = local.private_subnets["bastion-snet"]
    },
    {
      from_port   = 5671
      to_port     = 5671
      protocol    = "tcp"
      description = "Allow ingress AMQP traffic"
      cidr_blocks = local.private_subnets["bastion-snet"]
    }
  ]
}

resource "aws_mq_broker" "rabbit-mq-broker" {
  broker_name = "${var.prefix}-rabbitmq-broker"

  engine_type        = "RabbitMQ"
  engine_version     = "3.13"
  host_instance_type = "mq.t3.micro"

  authentication_strategy = "simple"

  security_groups = [module.rabbitmq-broker-sg.security_group_id]

  subnet_ids = [
    module.vpc.private_subnets[1]
  ]

  auto_minor_version_upgrade = true
  deployment_mode            = "SINGLE_INSTANCE"

  storage_type = "ebs"

  publicly_accessible = false

  user {
    username = "autoblog-user"
    password = "autoblog-user!"
  }
}
