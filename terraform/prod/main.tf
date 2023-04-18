# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket = "teradaterraform"
    key    = "prod/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
#-------------------------------------------------------
# 全体で使う変数
#-------------------------------------------------------
variable "NAMEBASE" {}
variable "ENV" {}
variable "CIRCLECI_RDS_PASSWORD" {}
#-------------------------------------------------------
# network
#-------------------------------------------------------
# moduleの利用
module "my_vpc" {
  # moduleの位置
  source = "../modules/network/"

  # 変数へ値の設定
  NameBase                   = var.NAMEBASE
  env                        = var.ENV
  cidr_block_VPC             = "10.0.0.0/16"
  cidr_block_PublicSubnet1a  = "10.0.0.0/20"
  cidr_block_PublicSubnet1b  = "10.0.16.0/20"
  cidr_block_PrivateSubnet1a = "10.0.128.0/20"
  cidr_block_PrivateSubnet1b = "10.0.144.0/20"
  AZ_1a                      = "ap-northeast-1a"
  AZ_1b                      = "ap-northeast-1c"
}
#-------------------------------------------------------
# securitygroup
#-------------------------------------------------------
# moduleの利用
module "my_securitygroup" {
  # moduleの位置
  source = "../modules/securitygroup/"

  # 変数へ値の設定
  NameBase = var.NAMEBASE
  env      = var.ENV

  vpc_id = module.my_vpc.VPCoutputs
}
#-------------------------------------------------------
# ec2
#-------------------------------------------------------
# moduleの利用
module "my_ec2" {
  # moduleの位置
  source = "../modules/ec2/"

  # 変数へ値の設定
  NameBase = var.NAMEBASE
  env      = var.ENV

  InstanceType    = "t2.micro"
  InstanceVolumes = "16"
  key_name        = "teradaterraform"
  volume_type     = "gp2"

  vpc_security_group = module.my_securitygroup.SecurityGroup01outputs
  publicsubnet1a     = module.my_vpc.PublicSubnet1aoutputs
  publicsubnet1b     = module.my_vpc.PublicSubnet1boutputs
}
#-------------------------------------------------------
# RDS
#-------------------------------------------------------
# moduleの利用
module "my_RDS" {
  # moduleの位置
  source = "../modules/rds/"
  # 変数へ値の設定
  NameBase = var.NAMEBASE
  env      = var.ENV

  InstanceClass           = "db.t2.small"
  MysqlVession            = "8.0.28"
  Username                = "admin"
  # CircleCIの環境変数使用
  rdspassword = var.CIRCLECI_RDS_PASSWORD
  Storage                 = "20"
  database_name           = "water"
  storage_type            = "gp2"
  backup_retention_period = "1"

  privatesubnet1a   = module.my_vpc.PrivateSubnet1aoutputs
  privatesubnet1b   = module.my_vpc.PrivateSubnet1boutputs
  RDS_securitygroup = module.my_securitygroup.SecurityGroup03outputs
}
#-------------------------------------------------------
# ALB
#-------------------------------------------------------
module "my_ALB" {
  # moduleの位置
  source = "../modules/alb/"
  # 変数へ値の設定
  NameBase = var.NAMEBASE
  env      = var.ENV

  publicSubnet1a   = module.my_vpc.PublicSubnet1aoutputs
  publicSubnet1b   = module.my_vpc.PublicSubnet1boutputs
  albsecuritygroup = module.my_securitygroup.SecurityGroup02outputs
  vpc_id           = module.my_vpc.VPCoutputs
}
#-------------------------------------------------------
# S3
#-------------------------------------------------------
module "my_s3" {
  # moduleの位置
  source = "../modules/s3/"
  # 変数へ値の設定
  NameBase = var.NAMEBASE
}