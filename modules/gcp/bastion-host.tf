module "bastion-host-vm" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-vm?ref=v38.0.0"
  project_id = module.project.project_id
  zone       = "${var.region}-a"
  name       = "${var.prefix}-bastion-vm"

  instance_type = "e2-standard-2"
  boot_disk = {
    initialize_params    = {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 20
      type  = "pd-balanced"
    }
    use_independent_disk = true
  }

  network_interfaces = [{
    network        = module.vpc.self_link
    subnetwork     = module.vpc.subnet_self_links["${var.region}/auto-blog-gke-snet"]
  }]
  
  service_account = {
    email = module.bastion-host-sa.email
    scopes = ["cloud-platform"]
  }
}

module "bastion-host-sa" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v38.0.0"

  project_id = module.project.project_id
  name       = "${var.prefix}-bastion-sa"

  iam = {
    "roles/iam.serviceAccountUser" = [
        module.github-sa.iam_email
    ]
  }
  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/logging.logWriter",
      "roles/container.defaultNodeServiceAccount"
    ]
  }
}