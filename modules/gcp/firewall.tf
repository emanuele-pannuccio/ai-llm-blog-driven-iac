module "firewall" {
  source  = "git::https://github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc-firewall?ref=v38.0.0"
  project_id     = module.project.project_id
  network      = module.vpc.name

  factories_config = {
    rules_folder  = "${path.module}/config/firewall/rules"
    cidr_tpl_file = "${path.module}/config/firewall/cidrs.yaml"
  }

  default_rules_config = { disabled = true }
}