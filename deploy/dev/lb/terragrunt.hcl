include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../infrastructure/lb"
}

dependency "lookup" {
  config_path = "../lookup"
}

inputs = {
  aws_region         = "us-west-2"
  vpc_id             = dependency.lookup.outputs.vpc_id
  public_subnets_ids = dependency.lookup.outputs.public_subnets_ids
  domain             = "lukewyman.dev"
}