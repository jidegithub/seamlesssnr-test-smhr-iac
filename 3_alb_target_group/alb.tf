locals {
  resource_name = trimsuffix(substr("${local.prefix}-ip-tg", 0, 32), "-")
  alb_arn       = data.terraform_remote_state.alb.outputs.alb_arn
  alb_sg        = data.terraform_remote_state.alb.outputs.alb_security_group_id
}

# ------- ALB Listener --------
# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = local.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ------- ALB Target Group --------
resource "aws_lb_target_group" "web" {
  name        = local.resource_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    {
      Name = local.resource_name
    },
    local.common_tags
  )
}

# ------- Add EC2 IPs to ALB Target Group --------
resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.nginx)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.nginx[count.index].private_ip
  port             = 80
}

resource "aws_iam_server_certificate" "seamless_cert" {
  name             = "seamless"
  certificate_body = file("~/self-signed-ca-pub.pem")
  private_key      = file("~/self-signed-ca-priv.pem")

  lifecycle {
    create_before_destroy = true
  }
}
