resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6"
  instance_class       = "db.t2.micro"
  name                 = "mlflow"
  username             = "mlflow"
  password             = var.master_password
  apply_immediately    = true
  port                 = 3306
  publicly_accessible  = true
  identifier           = "mlflow-db"
  skip_final_snapshot  = true
}


#############
# RDS Aurora
#############

/* module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                            = "test-aurora-db-postgres96"

  engine                          = "aurora-mysql"
  engine_mode                     = "serverless"

  vpc_id                          = aws_vpc.vpc.id
  subnets                         = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]
  enable_http_endpoint    = true
  port                    = 3306
  database_name           = "mlflow"
  username         = "mlflow"
  password         = var.master_password
  backup_retention_period = 7
  replica_count                   = 0
  instance_type                   = "db.t2.micro"
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10

  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  scaling_configuration   = {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
} */

/* resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-db"
  engine                  = "aurora-mysql"
  engine_mode             = "serverless"
  enable_http_endpoint    = true
  database_name           = "mlflow"
  master_username         = "mlflow"
  master_password         = var.master_password
  backup_retention_period = 7
  #vpc_security_group_ids = [aws_vpc.vpc.default_security_group_id]
  apply_immediately       = true
  port                    = 3306
  storage_encrypted       = true
  deletion_protection     = true

  scaling_configuration   {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
} */

