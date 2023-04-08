variable "aws_region" {
  default = "us-west-2"
}

variable "cluster_name" {
  default = ""
}

variable "service_name" {
  default = "song-lib"
}

variable "app_subnets_ids" {
  type    = list(string)
  default = ""
}

variable "security_group_id" {
  default = ""
}

variable "listener_arn" {
  default = ""
}

variable "priority" {
  default = "10"
}

variable "vpc_id" {
  default = ""
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