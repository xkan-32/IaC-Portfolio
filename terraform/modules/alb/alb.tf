#-------------------------------------------------------
#　ALB
#-------------------------------------------------------
resource "aws_lb" "TeradaALB" {
  name               = "ALB-${var.NameBase}"
  internal           = false
  load_balancer_type = "application"
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
  name        = "TargetGroup-${var.NameBase}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
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
locals {
  ec2_instances = [
    var.EC2_1,
    var.EC2_2,
  ]
}
resource "aws_lb_target_group_attachment" "Teradaattachment" {
  for_each = toset(local.ec2_instances)

  target_group_arn = aws_lb_target_group.TeradaTargetGroup.arn
  target_id        = each.value
  port             = 80
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