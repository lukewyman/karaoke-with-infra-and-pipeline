terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../infrastructure/microservice"
}

dependency "lookup" {
  config_path = "../../lookup"
}

dependency "ecs" {
  config_path = "../../ecs"
}

dependency "lb" {
  config_path = "../../lb"
}

inputs = {
  app_subnets_ids       = dependency.lookup.outputs.app_subnets_ids
  aws_region            = "us-west-2"
  cluster_name          = dependency.ecs.outputs.cluster_name
  ecs_security_group_id = dependency.ecs.outputs.security_group_id
  lb_listener_arn       = dependency.lb.outputs.lb_listener_arn
  vpc_id                = dependency.lookup.outputs.vpc_id
}