variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-083406a44c7f13237"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-0538edd709c8888b2",
    "subnet-0536ac54e0e3016eb",
  ]
}

variable "domain" {
  type    = string
  default = "lukewyman.dev"
}