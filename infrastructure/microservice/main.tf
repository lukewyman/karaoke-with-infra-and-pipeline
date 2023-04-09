resource "aws_ecs_service" "service" {
  name            = "${var.app_prefix}${terraform.workspace}-${var.service_name}-service"
  cluster         = var.cluster_name # aws_ecs_cluster.cluster.name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.app_subnets_ids
    security_groups  = [var.ecs_security_group_id] # [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target.arn
    container_name   = var.service_name
    container_port   = 8081
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = var.lb_listener_arn # aws_lb_listener.listener.arn
  priority     = var.priority

  condition {
    path_pattern {
      values = ["/songs*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_ecr_repository" "image_repo" {
  name = "${var.app_prefix}${terraform.workspace}-${var.service_name}"
}

resource "docker_registry_image" "image" {
  name = "${aws_ecr_repository.image_repo.repository_url}:${var.image_tag}"

  build {
    context    = "${path.module}/${var.context}"
    dockerfile = "Dockerfile"
  }
}

resource "aws_lb_target_group" "target" {
  name        = "${var.service_name}-target-${terraform.workspace}"
  protocol    = "HTTP"
  port        = 8081
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = docker_registry_image.image.name
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
        }
      ]
      environment = [{
        name  = "DOCDB_ENDPOINT"
        value = var.docdb_endpoint
        },
        {
          name  = "DOCDB_PORT"
          value = var.docdb_port
      }]
      secrets = [{
        name      = "DOCDB_USERNAME"
        valueFrom = var.docdb_username_arn
        },
        {
          name      = "DOCDB_PASSWORD"
          valueFrom = var.docdb_password_arn
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.aws_region
          awslogs-group         = aws_cloudwatch_log_group.log.name
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/${var.cluster_name}/${var.service_name}"
  retention_in_days = 14
}

resource "aws_iam_role" "task_role" {
  name               = "${var.app_prefix}${terraform.workspace}-${var.service_name}-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

resource "aws_iam_role_policy" "logging_policy" {
  name   = "${var.app_prefix}${terraform.workspace}-${var.service_name}-logging-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.logging_policy.json
}

resource "aws_iam_role_policy" "ecr_policy" {
  name   = "${var.app_prefix}${terraform.workspace}-${var.service_name}-ecr-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role_policy" "ssm_policy" {
  name   = "${var.app_prefix}${terraform.workspace}-${var.service_name}-ssm-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.ssm_policy.json
}