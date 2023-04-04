include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_parent_terragrunt_dir("root")}/../terraform-modules/ecr"
}

inputs = {
    aws_region = "us-west-2"
    app_name = "song-library"
    context = "../../../../../../../microservices/song_library"
    image_tag = 1
}