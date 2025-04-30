locals {
  repo_prefix = "ai-llm-blog-driven"
  repositories = [
    "cluster-manifests",
    "crawler",
    "aws-tunnel",
    "be",
    "fe",
    "ai-agent",
    "ai-ollama",
  ]
}

resource "github_repository" "default" {
  for_each   = toset(local.repositories)
  name       = "${local.repo_prefix}-${each.key}"
  visibility = "public"
}

resource "github_actions_secret" "example_secret" {
  for_each        = toset(local.repositories)
  repository      = github_repository.default[each.key].name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = module.gcp-infra.github_sa_key
}
