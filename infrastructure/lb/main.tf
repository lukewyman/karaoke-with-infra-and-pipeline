resource "aws_lb" "lb" {
  name               = "${local.app_prefix}${terraform.workspace}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_security_group" "lb_sg" {
  name        = "${local.app_prefix}${terraform.workspace}-lb-sg"
  description = "Load balancer security firewall"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "karaoke_A_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "karaoke.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.ssl_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "Unauthorized"
      status_code  = 401
    }
  }
}
