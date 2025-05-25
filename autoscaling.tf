
data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_launch_template" "terracloud-lauchtemplate" {
  name_prefix            = "nginx-autscaling"
  instance_type          = var.instance_type
  image_id               = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = filebase64("${path.module}/templates/startup_script.tpl")
  iam_instance_profile {
    name = "module.web_app_s3.instance_profile.name"
  }

  depends_on = [module.web_app_s3, aws_db_instance.terracloud-rds-db]
  tags       = local.common_tags
}

resource "aws_autoscaling_group" "terracloud-autoscaling-group" {
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  vpc_zone_identifier       = slice(module.app.private_subnets.ids, 0, 2)
  health_check_type         = "ELB"
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]
  target_group_arns         = [aws_lb_target_group.nginx-http.arn, aws_lb_target_group.nginx-https.arn]

  lifecycle {
    ignore_changes = [min_size, desired_capacity, target_group_arns]
  }

  launch_template {
    id      = aws_launch_template.terracloud-lauchtemplate.id
    version = "$Latest"
  }
}

# Target Tracking Scaling Policies
# Scaling Policy: Based on CPU Utilization

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_50" {
  name                      = "avg-cpu-policy-greater-than-50"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.terracloud-autoscaling-group.id
  estimated_instance_warmup = 180

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

}