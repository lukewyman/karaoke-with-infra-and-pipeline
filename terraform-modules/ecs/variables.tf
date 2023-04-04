variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "service_name" {
  type    = string
  default = "song-library"
}

variable "vpc_id" {
  default = "vpc-0ba91c206e32daaa5"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-09ce45747eb4ed3c0",
    "subnet-0415363f7b1ee9f7e",
  ]
}

variable "target_group_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:us-west-2:919980474747:targetgroup/karaoke-app-lb-dev-target/3e52cbb6c229eb74"
}

variable "image_uri" {
  type    = string
  default = "919980474747.dkr.ecr.us-west-2.amazonaws.com/karaoke-app-ecs-dev-song-library:1"
}

variable "docdb_endpoint" {
  default = "karaoke-base-infrastructure-docdb-dev-cluster.cluster-csxfgflyi7ar.us-west-2.docdb.amazonaws.com"
}

variable "docdb_username_arn" {
  default = "arn:aws:ssm:us-west-2:919980474747:parameter/app/karaoke/DOCDB_USERNAME"
}

variable "docdb_password_arn" {
  default = "arn:aws:ssm:us-west-2:919980474747:parameter/app/karaoke/DOCDB_PASSWORD"
}

variable "docdb_port" {
  default = "27017"
}