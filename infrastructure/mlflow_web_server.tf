resource "aws_security_group" "application_load_balancer" {
    name = "${var.project_name}-${var.stage}-alb-web-sg"
    description = "Allow all inbound traffic"
    vpc_id = data.aws_vpc.selected.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-${var.stage}-alb-web-sg"
    }
}


resource "aws_security_group" "web_server_ecs_internal" {
    name = "${var.project_name}-${var.stage}-web-server-ecs-internal-sg"
    description = "Allow all inbound traffic"
    vpc_id = data.aws_vpc.selected.id

    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        security_groups = [aws_security_group.application_load_balancer.id]
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-${var.stage}-web-server-ecs-internal-sg"
    }
}


resource "aws_ecs_task_definition" "web_server" {
  family = "${var.project_name}-${var.stage}-web-server"
  # container_definitions = file("airflow-components/web_server.json")
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_iam_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu = "1024" # the valid CPU amount for 2 GB is from from 256 to 1024
  memory = "2048"
  container_definitions = <<EOF
[
  {
    "name": "mlflow_web_server",
    "image": ${replace(jsonencode("${aws_ecr_repository.docker_repository.repository_url}:${var.image_version}"), "/\"([0-9]+\\.?[0-9]*)\"/", "$1")} ,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ],
    "environment": [
      {
        "name": "BUCKET_NAME",
        "value": "${var.project_name}-${var.stage}-${var.account}"
      },
      {
          "name": "DB_ENDPOINT",
          "value": "${aws_rds_cluster.default.endpoint}"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.log_group_name}/${var.project_name}-${var.stage}",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "web_server"
        }
    }
  }
]
EOF
}