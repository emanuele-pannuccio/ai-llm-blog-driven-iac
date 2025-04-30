module "artifact-registry" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/artifact-registry?ref=v38.0.0"
  project_id = module.project.project_id
  location   = var.region
  name       = "${var.prefix}-gar"
  format     = { docker = { standard = {} } }
  iam = {
    "roles/artifactregistry.admin" = [module.github-sa.iam_email]
    "roles/artifactregistry.reader" = [
      module.cluster-gke-nodepool-cpu-1.service_account_iam_email,
      module.cluster-gke-nodepool-gpu-1.service_account_iam_email
    ]
  }
}
