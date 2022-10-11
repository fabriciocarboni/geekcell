/*
 * elb.tf
 * Creates Application Load Balancer
 */


resource "aws_lb" "application-lb" {
  name               = "main-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.public-a.id, aws_subnet.public-b.id]

  tags = {
    Name = "Application Load Balancer"
  }
}

# Creating target group
resource "aws_lb_target_group" "alb-tg" {
  name        = "alb-tg"
  port        = 8081
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

}


resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.id
  }
}


output "ELB_DNS_NAME" {
  description = "The DNS name of the ELB"
  value       = aws_lb.application-lb.dns_name
}
