locals {
  workloads = ["blog-feed-crawler", "blog-ai-agent", "blog-be"]
}

module "secret-manager" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/secret-manager?ref=v39.0.0"
  project_id = module.project.project_id
  secrets = merge(
    {
      "mysql-connection" = {
        locations = [var.region]
      }
      "rabbit-connection" = {
        locations = [var.region]
      }
      "mongodb-connection" = {
        locations = [var.region]
      }
    }
  )
  iam = merge(
    {
      mysql-connection = {
        "roles/secretmanager.secretAccessor" = [for sa in module.service-account : sa.iam_email]
      }
      rabbit-connection = {
        "roles/secretmanager.secretAccessor" = [for sa in module.service-account : sa.iam_email]
      }
      mongodb-connection = {
        "roles/secretmanager.secretAccessor" = [for sa in module.service-account : sa.iam_email]
      }
    },
  )
}
