resource "aws_db_subnet_group" "terracloud-db-subnet-group" {
  name       = "terracloud-db-subnet-group"
  subnet_ids = slice(module.app.private_subnets.ids, 2, 4)

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-rds-subent-group"
  })
}

resource "aws_db_instance" "terracloud-rds-db" {
  allocated_storage = 20
  identifier        = "terracloud-rds-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "mydb"
  username          = "terracloud"
  password          = "sgsdfjh43r24"
  #To Integrating RDS master user passwords with Secrets Manager,RDS automatically generates database credentials & stores in AWS Secrets Manager.
  #manage_master_user_password = true

  multi_az                = true
  publicly_accessible     = false
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = true
  deletion_protection     = true
  storage_encrypted       = true
  backup_retention_period = 7
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = local.common_tags
}

output "rds_endpoint" {
  value = aws_db_instance.terracloud-rds-db.endpoint
}

output "db_name" {
  value = aws_db_instance.terracloud-rds-db.db_name
}

output "db_username" {
  value = aws_db_instance.terracloud-rds-db.username
}

output "db_password" {
  value     = aws_db_instance.terracloud-rds-db.password
  sensitive = true
}