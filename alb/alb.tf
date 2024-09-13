# Creating External LoadBalancer
variable "subnet_ids" {
  type = list(any)
}

variable "albsg_id" {
  type = list(any)
}

variable "vpc_id" {

}


variable "ansible-master-america" {

}

variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}

resource "aws_lb" "external-alb-america" {
  name               = "external-alb-america"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.albsg_id
  subnets            = var.subnet_ids
  tags = {
    Name        = "external-alb-america"
    Environment = lower(var.env)
    Project     = lower(var.project)
  }
}

resource "aws_lb_target_group" "targetgroup-alb-america" {
  name     = "targetgroup-alb-america"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "targetgroupattachment-america-1" {
  target_group_arn = aws_lb_target_group.targetgroup-alb-america.arn
  target_id        = var.ansible-master-america.id
  port             = 80

  depends_on = [
    var.ansible-master-america
  ]
}

resource "aws_lb_listener" "listeneralb-america" {
  load_balancer_arn = aws_lb.external-alb-america.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup-alb-america.arn
  }
}

output "alb_items" {
  value = [
    aws_lb.external-alb-america.arn
  , aws_lb.external-alb-america.dns_name]
}
