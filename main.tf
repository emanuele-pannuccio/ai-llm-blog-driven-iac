module "tf-state-bucket" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gcs?ref=v38.0.0"
  project_id = var.gcp.project
  name       = var.state_bucket
  location   = "europe-west4"

  lifecycle_rules = {
    lr-0 = {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = 3
      }
    }
  }
}

# module "aws-infra" {
#   source = "./modules/aws"
#   prefix = var.prefix

#   gcp = {
#     nat_ip = module.gcp-infra.nat_gateway
#     workloads = [
#       "crawler", "ai-agent", "blog-be"
#     ]
#   }

#   vpc = {
#     cidr = var.aws.cidr
#   }
# }

module "gcp-infra" {
  source  = "./modules/gcp"
  project = var.gcp.project

  region = var.gcp.region

  prefix = var.prefix
  env    = lower(var.env)
}
