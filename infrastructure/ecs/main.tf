resource "aws_ecs_cluster" "cluster" {
  name = "${local.app_prefix}${terraform.workspace}-cluster"
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${local.app_prefix}${terraform.workspace}-ecs-sg"
  description = "ECS container security firewall"

  vpc_id = var.vpc_id

  ingress {
    from_port   = var.from_port 
    to_port     = var.to_port 
    protocol    = "tcp"
    cidr_blocks = var.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

