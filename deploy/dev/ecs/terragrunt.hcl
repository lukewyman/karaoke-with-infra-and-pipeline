include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../infrastructure/ecs"
}

dependency "lookup" {
  config_path = "../lookup"
}

inputs = {
  aws_region                 = "us-west-2"
  vpc_id                     = dependency.lookup.outputs.vpc_id
  public_subnets_cidr_blocks = dependency.lookup.outputs.public_subnets_cidr_blocks
  from_port                  = 8081
  to_port                    = 8081
}