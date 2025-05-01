variable "state_bucket" {
  type     = string
  nullable = false
}

variable "prefix" {
  type     = string
  nullable = false
}

variable "env" {
  type     = string
  nullable = false
}

variable "gcp" {
  type = object({
    project = string
    region  = string
  })
  nullable = false
}

variable "aws" {
  type = object({
    cidr = string
  })
}
