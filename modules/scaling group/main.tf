resource "aws_launch_configuration" "public_lc" {
  name          = "web-launch-configuration"
  image_id     = var.ami
  instance_type = "t2.micro"
  security_groups = [var.pub_security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "public_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  vpc_zone_identifier = [var.public_subnet_az1_id]

  launch_configuration = aws_launch_configuration.public_lc.id

  tag {
    key                 = "Name"
    value               = "WebServerASG"
    propagate_at_launch = true
  }
 
  health_check_type          = "EC2"
  health_check_grace_period = 300
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment      = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.public_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment      = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

####################################################################

resource "aws_launch_configuration" "private_lc" {
  name          = "web-launch-configuration"
  image_id     = var.ami
  instance_type = "t2.micro"
  security_groups = [var.priv_security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "private_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  vpc_zone_identifier = [var.private_subnet_az1_id]

  launch_configuration = aws_launch_configuration.private_lc.id

  tag {
    key                 = "Name"
    value               = "WebServerASG"
    propagate_at_launch = true
  }
 
  health_check_type          = "EC2"
  health_check_grace_period = 300
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment      = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.private_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment      = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.private_asg.name
}
