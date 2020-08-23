resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6"
  instance_class       = "db.t2.micro"
  name                 = "mlflow"
  username             = var.master_username
  password             = var.master_password
  apply_immediately    = true
  port                 = 3306
  publicly_accessible  = true
  identifier           = "mlflow-db"
  skip_final_snapshot  = true
}
