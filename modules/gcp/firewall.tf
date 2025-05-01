module "firewall" {
  source     = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc-firewall?ref=v38.0.0"
  project_id = module.project.project_id
  network    = module.vpc.name

  factories_config = {
    rules_folder = "${path.root}/config/gcp/firewall/${var.env}/rules"
    # cidr_tpl_file = "${path.root}/config/gcp/firewall/${var.env}/cidrs.yaml"
  }

  default_rules_config = { disabled = true }
}
