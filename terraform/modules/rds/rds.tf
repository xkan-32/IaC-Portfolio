#-------------------------------------------------------
# サブネットグループ
#-------------------------------------------------------
resource "aws_db_subnet_group" "TeradaDBSubnetGroup" {
  name = "dbsubnetgroup-${var.NameBase}"

  subnet_ids = [
    var.privatesubnet1a, var.privatesubnet1b
  ]
  tags = {
    Name        = "RDS_KMS-${var.NameBase}"
    Environment = var.env
  }
}
#-------------------------------------------------------
# パラメータグループ
#-------------------------------------------------------
resource "aws_db_parameter_group" "Teradaparametergroup" {
  name   = "parametergroup-${var.NameBase}"
  family = "mysql8.0"
  parameter {
    name  = "slow_query_log"
    value = 1
  }
  parameter {
    name  = "general_log"
    value = 1
  }
  parameter {
    name  = "long_query_time"
    value = 5
  }
}
#-------------------------------------------------------
# KMS
#-------------------------------------------------------
resource "aws_kms_key" "TeradaRDSencryptKey" {
  description             = "key to encrypt RDS"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "RDS_KMS-${var.NameBase}"
    Environment = var.env
  }
}
#-------------------------------------------------------
# RDS
#-------------------------------------------------------
resource "aws_db_instance" "TeradaDatabases" {
  identifier     = "dbinstance-${var.NameBase}"
  instance_class = var.InstanceClass
  engine         = "mysql"
  engine_version = var.MysqlVession
  username       = var.Username
  password       = var.rdspassword
  # tfstateに記載される為、使用せず
  #  manage_master_user_password = true
  db_name                  = var.database_name
  backup_retention_period  = var.backup_retention_period
  multi_az                 = true
  publicly_accessible      = false
  storage_type             = var.storage_type
  allocated_storage        = var.Storage
  storage_encrypted        = true
  parameter_group_name     = aws_db_parameter_group.Teradaparametergroup.name
  kms_key_id               = aws_kms_key.TeradaRDSencryptKey.arn
  copy_tags_to_snapshot    = false
  delete_automated_backups = true
  deletion_protection      = false
  skip_final_snapshot      = true
  vpc_security_group_ids   = [var.RDS_securitygroup]
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  db_subnet_group_name = aws_db_subnet_group.TeradaDBSubnetGroup.name
  tags = {
    Name        = "RDS-${var.NameBase}"
    Environment = var.env
  }
}
#-------------------------------------------------------
# リードレプリカ
#-------------------------------------------------------
# resource "aws_db_instance" "TeradaDatabasesReadReplica" {
#   identifier             = "dbinstancereadreplica-${var.NameBase}"
#   instance_class         = var.InstanceClass
#   replicate_source_db    = aws_db_instance.TeradaDatabases.id
#   parameter_group_name   = aws_db_parameter_group.Teradaparametergroup.name
#   vpc_security_group_ids = [var.RDS_securitygroup]
#   tags = {
#     Name        = "RDSReadReplica-${var.NameBase}"
#     Environment = var.env
#   }
# }
#-------------------------------------------------------
# OutPuts
#-------------------------------------------------------
output "TeradaDatabasesoutputs" {
  value = aws_db_instance.TeradaDatabases.endpoint
}