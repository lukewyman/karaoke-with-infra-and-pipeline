variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0ba91c206e32daaa5"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-0e64262705cc5b5d8",
    "subnet-088282acf44847367",
  ]
}

variable "domain" {
  type = string 
  default = "lukewyman.dev"
}