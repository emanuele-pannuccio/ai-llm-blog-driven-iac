state_bucket = "auto-blog-prod-tf-state-bkt"
prefix       = "autoblog-prod"
env          = "PROD"

gcp = {
  project = "gcp-automated-blog-prod"
  region  = "europe-west4"
}

aws = {
  cidr = "10.0.1.0/25"
}
