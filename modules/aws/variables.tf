variable "prefix" {
  type    = string
  default = "automated-blog"
}

variable "gcp_nat_gateway" {
  type     = string
  nullable = false
}
