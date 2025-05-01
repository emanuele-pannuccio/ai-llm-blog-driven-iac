module "mysql-database-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.prefix}-db"
  description = "MySQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      cidr_blocks = local.private_subnets["bastion-snet"]
      protocol    = "tcp"
      description = "MySQL access from within VPC"
    },
  ]

  egress_with_cidr_blocks = []
}

module "mysql-database" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.prefix}-db"

  create_db_instance = true

  engine               = "mysql"
  engine_version       = "8.0.41"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  #   publicly_accessible = true


  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 0

  db_name  = "automated_blog"
  username = "autoblog_user"
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.mysql-database-sg.security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  tags = {}

  subnet_ids = module.vpc.database_subnets


  multi_az = false

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}
