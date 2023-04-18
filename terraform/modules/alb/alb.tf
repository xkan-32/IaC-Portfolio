#-------------------------------------------------------
#　ALB
#-------------------------------------------------------
resource "aws_lb" "TeradaALB" {
  name     = "ALB-${var.NameBase}"
  internal = false
  subnets = [
    var.publicSubnet1a,
    var.publicSubnet1b
  ]
  security_groups = [var.albsecuritygroup]

  tags = {
    Name        = "ALB-${var.NameBase}"
    Environment = var.env
  }
}
#-------------------------------------------------------
# target_group
#-------------------------------------------------------
resource "aws_lb_target_group" "TeradaTargetGroup" {
  name     = "TargetGroup-${var.NameBase}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "TargetGroup-${var.NameBase}"
    Environment = var.env
  }
}
#-------------------------------------------------------
# listener
#-------------------------------------------------------
resource "aws_lb_listener" "TeradaListenerHTTP" {
  load_balancer_arn = aws_lb.TeradaALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.TeradaTargetGroup.arn
    type             = "forward"
  }
}
#-------------------------------------------------------
# OutPuts
#-------------------------------------------------------
output "TeradaALBsoutputs" {
  value = aws_lb.TeradaALB.dns_name
}