state_bucket = "auto-blog-test-tf-state-bkt"
prefix       = "autoblog-test"
env          = "TEST"

gcp = {
  project = "gcp-automated-blog-test"
  region  = "europe-west4"
}

aws = {
  cidr = "10.0.0.0/25"
}
