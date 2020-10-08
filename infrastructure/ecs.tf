resource "aws_ecr_repository" "docker_repository" {
    name = "${var.project_name}-${var.stage}"
}

resource "aws_ecr_lifecycle_policy" "docker_repository_lifecycly" {
  repository = aws_ecr_repository.docker_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only the latest 5 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.stage}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.log_group_name}/${var.project_name}-${var.stage}"
  retention_in_days = 5
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name = "${var.project_name}-${var.stage}-ecs-task-role"
  description = "Allow ECS tasks to access AWS resources"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.project_name}-${var.stage}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ecs_task_iam_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}


# ECS Services
resource "aws_ecs_service" "web_server_service" {
    name = "${var.project_name}-${var.stage}-web-server"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.web_server.arn
    desired_count = 2
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    health_check_grace_period_seconds = 60

    capacity_provider_strategy {
        capacity_provider = "FARGATE_SPOT"
        weight            = 100
    }

    network_configuration {
        security_groups  = [aws_security_group.web_server_ecs_internal.id]
        subnets          = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.web_server.id
        container_name = "mlflow_web_server"
        container_port = 5000
    }

    depends_on = [
        aws_rds_cluster.default,
        aws_alb_listener.web_server,
    ]
}