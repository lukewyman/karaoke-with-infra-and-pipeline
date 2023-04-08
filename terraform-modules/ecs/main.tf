resource "aws_ecs_cluster" "cluster" {
  name = "${local.app_prefix}${terraform.workspace}-${var.service_name}-cluster"
}

resource "aws_ecs_service" "service" {
  name            = "${local.app_prefix}${terraform.workspace}-${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.service_name
    container_port   = 8081
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${local.app_prefix}${terraform.workspace}-lb-sg"
  description = "Load balancer security firewall"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
      image     = var.image_uri
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

resource "aws_iam_role" "task_role" {
  name               = "${local.app_prefix}${terraform.workspace}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_policy.json
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/${local.app_prefix}${terraform.workspace}/${var.service_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy" "task_logging_role_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-${var.service_name}-log-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.logging_policy.json 
}

resource "aws_iam_role_policy" "task_ecr_role_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-${var.service_name}-ecr-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role_policy" "task_ssm_role_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-${var.service_name}-ssm-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.ssm_policy.json
}
