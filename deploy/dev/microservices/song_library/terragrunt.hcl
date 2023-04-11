include "root" {
  path = find_in_parent_folders()
}

include "microservice" {
  path = "${get_terragrunt_dir()}/../../../_env/microservice.hcl"
}

inputs = {
  app_name   = "song-library"
  app_prefix = "karaoke-app-svc-song-lib-"
  container_params = {
    name           = "song-lib"
    container_port = 8081
    host_port      = 8081
    environment = {
      "DOCDB_ENDPOINT" = dependency.lookup.outputs.docdb_endpoint
      "DOCDB_PORT"     = dependency.lookup.outputs.docdb_port
    }
    secrets = {
      "DOCDB_USERNAME" = dependency.lookup.outputs.docdb_username_arn
      "DOCDB_PASSWORD" = dependency.lookup.outputs.docdb_password_arn
    }
  }
  context            = "../../../../../../../microservices/song_library"
  docdb_password_arn = dependency.lookup.outputs.docdb_password_arn
  docdb_username_arn = dependency.lookup.outputs.docdb_username_arn
  image_tag          = 1
  priority           = 10
  service_name       = "song-lib"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
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
      prefix = "karaoke-app-svc-song-lib-"
    }
  }
}
    EOF
}