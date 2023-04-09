variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  default = "vpc-01d79b504bbfedf89"
}

variable "public_subnets_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]
}

variable "from_port" {
  default = 8081
}

variable "to_port" {
  default = 8081
}
