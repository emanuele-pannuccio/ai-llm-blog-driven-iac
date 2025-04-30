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

module "aws-infra" {
  source          = "./modules/aws"
  prefix          = var.prefix
  gcp_nat_gateway = module.gcp-infra.nat_gateway
}

module "gcp-infra" {
  source = "./modules/gcp"

  project = var.gcp.project
  prefix  = var.prefix
  region  = var.gcp.region
}
