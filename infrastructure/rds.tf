data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "db" {
  name        = "mlflow-db-sg"
  description = "Allow Aurora requests"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "mlflow-metadata-db"
  availability_zones      = var.availability_zones
  database_name           = "mlflow"
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  apply_immediately       = true
  port                    = 3306
  engine                  = "aurora-mysql"
  engine_mode             = "serverless"
  enable_http_endpoint    = true
  vpc_security_group_ids  = [aws_security_group.db.id]

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}