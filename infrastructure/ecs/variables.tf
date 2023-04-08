variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  default = "vpc-083406a44c7f13237"
}

variable "public_subnets_cidr_blocks" {
  type = list(string)
  default = []
}
