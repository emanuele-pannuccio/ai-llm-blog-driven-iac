module "secret-manager" {
  source  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/secret-manager?ref=v39.0.0"
  project_id = module.project.project_id
  secrets = {
    aws-access-key-id = {
      locations = [var.region]
    }
    aws-secret-access-key = {
      locations = [var.region]
    }
    mysql-connection = {
      locations = [var.region]
    }
    rabbit-connection = {
      locations = [var.region]
    }
    mongodb-connection = {
      locations = [var.region]
    }
  }
  iam = {
    aws-access-key-id = {
      "roles/secretmanager.secretAccessor" = [
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-ai-agent/sa/blog-ai-agent-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-feed-crawler/sa/blog-feed-crawler-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-be/sa/blog-be-sa"
      ]
    }
    aws-secret-access-key = {
      "roles/secretmanager.secretAccessor" = [
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-ai-agent/sa/blog-ai-agent-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-feed-crawler/sa/blog-feed-crawler-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-be/sa/blog-be-sa"
      ]
    }
    mysql-connection = {
      "roles/secretmanager.secretAccessor" = [
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-ai-agent/sa/blog-ai-agent-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-be/sa/blog-be-sa"
      ]
    }
    rabbit-connection = {
      "roles/secretmanager.secretAccessor" = [
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-ai-agent/sa/blog-ai-agent-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-feed-crawler/sa/blog-feed-crawler-sa"
      ]
    }
    mongodb-connection = {
      "roles/secretmanager.secretAccessor" = [
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-ai-agent/sa/blog-ai-agent-sa",
        "principal://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/blog-feed-crawler/sa/blog-feed-crawler-sa"
      ]
    }
  }
}