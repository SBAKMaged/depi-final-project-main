resource "aws_lb" "elastic_load_balancer" {
  name               = "elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  

  enable_deletion_protection = true


  tags = {
    Environment = "${var.project_name}-elb"
  }
}


resource "aws_lb_target_group" "elb_target_groub" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 30
    timeout             = 20
    healthy_threshold   = 5
    unhealthy_threshold = 2
  } 
}




resource "aws_lb_listener" "web_listener_80" {
  load_balancer_arn = aws_lb.elastic_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
      type             = "redirect"
      redirect {
        protocol = "HTTPS"
        port     = "443"
        status_code = "HTTP_301"
      }
      

    target_group_arn = aws_lb_target_group.elb_target_groub.arn
  }
}



