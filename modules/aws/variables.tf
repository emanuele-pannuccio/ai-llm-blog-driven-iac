variable "prefix" {
  type    = string
  default = "automated-blog"
}

variable "vpc" {
  type = object({
    cidr = string
  })
  nullable = false
}

variable "gcp" {
  type = object({
    workloads = list(string)
    nat_ip    = string
  })
}
