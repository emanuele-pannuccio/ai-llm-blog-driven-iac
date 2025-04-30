module "github-sa" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v38.0.0"
  project_id = module.project.project_id
  name       = "${var.prefix}-gh-sa"
  iam = {
  }
  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/iap.tunnelResourceAccessor",
      "roles/compute.instanceAdmin.v1",
      "roles/container.clusterViewer"
    ]
  }
}

resource "google_service_account_key" "github-sa-key" {
  service_account_id = module.github-sa.id
  public_key_type    = "TYPE_X509_PEM_FILE"
}
