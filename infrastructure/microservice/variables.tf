variable "app_name" {
}

variable "app_prefix" {
}

variable "app_subnets_ids" {
  type = list(string)
}

variable "aws_region" {
}

variable "cluster_name" {
}

variable "container_params" {
  type = object({
    name           = string
    container_port = number 
    host_port      = number
    environment    = map(string)
    secrets        = map(string)    
  })
  description = "Container definition assigned to ECS Task"
}

variable "context" {
}

variable "docdb_password_arn" {
}


variable "docdb_username_arn" {
}

variable "ecs_security_group_id" {
}

variable "image_tag" {
}

variable "lb_listener_arn" {
}

variable "priority" {
  default = "10"
}

variable "service_name" {
}

variable "vpc_id" {
}
