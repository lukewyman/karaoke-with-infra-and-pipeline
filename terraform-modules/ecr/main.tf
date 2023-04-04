resource "aws_ecr_repository" "image_repo" {
  name = "${local.app_prefix}${terraform.workspace}-${var.app_name}"
}

resource "docker_registry_image" "image" {
  name = "${aws_ecr_repository.image_repo.repository_url}:${var.image_tag}"

  build {
    context    = "${path.module}/${var.context}"
    dockerfile = "Dockerfile"
  }
}