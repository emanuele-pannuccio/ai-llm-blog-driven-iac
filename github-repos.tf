resource "github_repository" "default_cluster-manifests" {
  name       = "ai-llm-blog-driven-cluster-manifests"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_cluster-manifests" {
  repository      = github_repository.default_cluster-manifests.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_crawler" {
  name       = "ai-llm-blog-driven-crawler"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_crawler" {
  repository      = github_repository.default_crawler.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_aws-tunnel" {
  name       = "ai-llm-blog-driven-aws-tunnel"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_aws-tunnel" {
  repository      = github_repository.default_aws-tunnel.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_be" {
  name       = "ai-llm-blog-driven-be"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_be" {
  repository      = github_repository.default_be.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_fe" {
  name       = "ai-llm-blog-driven-fe"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_fe" {
  repository      = github_repository.default_fe.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_ai-agent" {
  name       = "ai-llm-blog-driven-ai-agent"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_ai-agent" {
  repository      = github_repository.default_ai-agent.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}

resource "github_repository" "default_ai-ollama" {
  name       = "ai-llm-blog-driven-ai-ollama"
  visibility = "public"
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "secret_ai-ollama" {
  repository      = github_repository.default_ai-ollama.name
  secret_name     = "GOOGLE_${var.env}_ENVIRONMENT_SA"
  plaintext_value = base64decode(module.gcp-infra.github_sa_key)
}
