variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-01d79b504bbfedf89"
}

variable "public_subnets_ids" {
  type = list(string)
  default = [
    "subnet-0e99f6b1dc7872563",
    "subnet-0c5e2a8f3f182872e",
  ]
}

variable "domain" {
  type    = string
  default = "lukewyman.dev"
}