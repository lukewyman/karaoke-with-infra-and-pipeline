include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../infrastructure/ecr"
}

inputs = {
  aws_region = "us-west-2"
  app_name   = "song-library"
  context    = "../../../../../../../microservices/song_library"
  image_tag  = 1
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite"
    contents = <<EOF
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.58.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces {
      prefix = "karaoke-app-song-lib-ecr-"
    }
  }
}
    EOF
}