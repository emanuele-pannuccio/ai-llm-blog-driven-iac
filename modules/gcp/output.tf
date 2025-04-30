output "nat_gateway" {
  value       = module.addresses.external_addresses["nat-address"].address
  description = "NAT Gateway IP"
}

output "github_sa_key" {
  value = google_service_account_key.github-sa-key.private_key
}
