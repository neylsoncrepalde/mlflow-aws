resource "aws_alb" "alb" {
  name            = "${var.project_name}-${var.stage}-alb"
  security_groups = [aws_security_group.application_load_balancer.id]
  subnets         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
}

resource "aws_alb_target_group" "web_server" {
    name        = "${var.project_name}-${var.stage}-web-server"
    port        = 5000
    protocol    = "HTTP"
    vpc_id      = data.aws_vpc.selected.id
    target_type = "ip"

    health_check {
        interval = 10
        port = 5000
        protocol = "HTTP"
        path = "/health"
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold = 3
    }
}

# port exposed from the application load balancer
resource "aws_alb_listener" "web_server" {
    load_balancer_arn = aws_alb.alb.id
    port = "80"
    protocol = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.web_server.id
        type = "forward"
    }
}