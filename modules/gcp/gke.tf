module "cluster-gke-nodepool-cpu-1" {
  source       = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-nodepool?ref=v38.0.0"
  project_id   = module.project.project_id
  cluster_name = module.gke.name
  location     = "${var.region}-a"
  name         = "${var.prefix}-gke-node-cpu-np"
  service_account = {
    create       = false
    email        = module.cluster-gke-nodepool-cpu-1-sa.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  node_config = {
    machine_type = "e2-standard-2"
    disk_size_gb = 20
    disk_type    = "pd-balanced"
    gvnic        = false
    spot         = false
  }
  nodepool_config = {
    management = {
      auto_repair  = true
      auto_upgrade = true
    }
  }
}

module "service-account" {
  source = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v38.0.0"

  for_each = toset(var.workloads)

  project_id = module.project.project_id
  name       = "gcp-${each.key}"

  iam = {
    "roles/iam.workloadIdentityUser" = ["serviceAccount:gcp-automated-blog-test.svc.id.goog[${each.key}/${each.key}-sa]"]
  }
}

module "cluster-gke-nodepool-gpu-1" {
  source       = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-nodepool?ref=v38.0.0"
  project_id   = module.project.project_id
  cluster_name = module.gke.name
  location     = "${var.region}-a"
  name         = "${var.prefix}-gke-node-gpu-np"
  service_account = {
    create       = false
    email        = module.cluster-gke-nodepool-gpu-1-sa.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  node_config = {
    machine_type        = "g2-standard-4"
    disk_size_gb        = 40
    disk_type           = "pd-balanced"
    ephemeral_ssd_count = 1
    gvnic               = true
    spot                = true
    guest_accelerator = {
      type  = "nvidia-l4"
      count = 1
      gpu_driver = {
        version = "LATEST"
      }
    }
  }
}

module "cluster-gke-nodepool-cpu-1-sa" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v38.0.0"

  project_id             = module.project.project_id
  service_account_create = true
  name                   = "${var.prefix}-gke-node-cpu"

  iam = {}

  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/logging.logWriter",
      "roles/container.defaultNodeServiceAccount"
    ]
  }
}

module "cluster-gke-nodepool-gpu-1-sa" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v38.0.0"

  project_id             = module.project.project_id
  service_account_create = true
  name                   = "${var.prefix}-gke-node-gpu"

  iam = {}

  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/logging.logWriter",
      "roles/container.defaultNodeServiceAccount"
    ]
  }
}

module "gke" {
  source = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-cluster-standard?ref=v38.0.0"

  project_id = module.project.project_id

  name = "${var.prefix}-gke-cluster"

  location = "${var.region}-a"

  deletion_protection = false

  access_config = {
    ip_access = {
      authorized_ranges = {
        internal-bastion = "10.0.1.0/29"
      }
    }
  }

  vpc_config = {
    network    = module.vpc.self_link
    subnetwork = module.vpc.subnet_self_links["${var.region}/auto-blog-gke-snet"]
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
  }

  default_nodepool = {
    remove_pool = true
  }

  enable_features = {
    workload_identity = true
    gateway_api       = true
  }

  enable_addons = {
    http_load_balancing = true
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.prefix}-ssl-cert"

  project = module.project.project_id

  managed {
    domains = ["${module.addresses.global_addresses["gke-gateway-gext-lb"].address}.nip.io"]
  }
}
