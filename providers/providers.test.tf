terraform {
  required_version = "1.11.3"

  backend "gcs" {
    bucket = "auto-blog-test-tf-state-bkt"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.28.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "6.28.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.96.0"
    }

  }
}

provider "google" {}

provider "google-beta" {}


provider "aws" {
  region = "eu-west-1"
}