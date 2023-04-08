data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces = {
      name = "karaoke-base-infrastructure-vpc-${terraform.workspace}"
    }
  }
}

data "terraform_remote_state" "docdb" {
  depends_on = [
    data.terraform_remote_state.vpc
  ]

  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces = {
      name = "karaoke-base-infrastructure-docdb-${terraform.workspace}"
    }
  }
}