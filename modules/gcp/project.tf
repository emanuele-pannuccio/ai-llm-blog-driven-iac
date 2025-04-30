module "project" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v39.0.0"
  name = var.project

  project_reuse = {
    use_data_source = true
  }

  services = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "certificatemanager.googleapis.com"
  ]
}
