module "addresses" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-address?ref=v38.0.0"
  project_id = module.project.project_id
  external_addresses = {
    nat-address = {
        region = var.region
    }
  }
  global_addresses = {
    gke-gateway-gext-lb = {}
  }
}

module "nat" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-cloudnat?ref=v38.0.0"
  project_id = module.project.project_id
  region         = var.region
  name           = "nat"
  router_network = module.vpc.self_link
  addresses = [
    module.addresses.external_addresses["nat-address"].self_link
  ]
  config_source_subnetworks = {}
}


module "vpc" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v38.0.0"

  project_id = module.project.project_id
  name       = "${var.prefix}-vpc"
  auto_create_subnetworks = false
  
  factories_config = {
    subnets_folder = "${path.module}/config/network"
  }
}