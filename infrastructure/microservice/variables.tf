variable "app_prefix" {
  default = "karaoke-app-ms-"
}

variable "app_subnets_ids" {
  type = list(string)
  default = [
    "subnet-098fba7719257d9c3",
    "subnet-069d0a8587e1a77b5",
  ]
}

variable "aws_region" {
  default = "us-west-2"
}

variable "cluster_name" {
  default = "karaoke-app-ecs-dev-cluster"
}

variable "context" {
  default = "../../microservices/song_library"
}

variable "docdb_endpoint" {
  default = "karaoke-base-infrastructure-docdb-dev-cluster.cluster-csxfgflyi7ar.us-west-2.docdb.amazonaws.com"
}

variable "docdb_password_arn" {
  default = "arn:aws:ssm:us-west-2:919980474747:parameter/app/karaoke/DOCDB_PASSWORD"
}

variable "docdb_port" {
  default = "27017"
}

variable "docdb_username_arn" {
  default = "arn:aws:ssm:us-west-2:919980474747:parameter/app/karaoke/DOCDB_USERNAME"
}

variable "ecs_security_group_id" {
  default = "sg-08fa7d0a0a211481e"
}

variable "image_tag" {
  default = 1
}

variable "lb_listener_arn" {
  default = "arn:aws:elasticloadbalancing:us-west-2:919980474747:listener/app/karaoke-app-lb-dev-lb/d9933abcfb1d5ce3/685e0d24cd0c3498"
}

variable "priority" {
  default = "10"
}

variable "service_name" {
  default = "song-lib"
}

variable "vpc_id" {
  default = "vpc-01d79b504bbfedf89"
}
