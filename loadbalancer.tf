# aws_elb_service_account

data "aws_elb_service_account" "root" {}

# aws_lb
resource "aws_lb" "nginx" {
  name               = "${local.naming_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = slice(module.app.public_subnets.ids, 0, 2)
  depends_on         = [module.web_app_s3]

  enable_deletion_protection = false

  access_logs {
    bucket  = module.web_app_s3.web_bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

# aws_lb_target_group
resource "aws_lb_target_group" "nginx-http" {
  name     = "${local.naming_prefix}-alb-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.app.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "nginx-https" {
  name     = "${local.naming_prefix}-alb-https-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = module.app.vpc_id

  health_check {
    protocol            = "HTTPS"
    path                = "/health"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = local.common_tags
}

# aws_lb_listener
resource "aws_lb_listener" "nginx-http" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-http.arn
  }

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-nginx-http"
  })
}

resource "aws_lb_listener" "nginx-https" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-https.arn
  }

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-nginx-https"
  })
}


# Not creating aws_lb_target_group_attachment, as we have integrated with Autoscaling with this Load balancer

