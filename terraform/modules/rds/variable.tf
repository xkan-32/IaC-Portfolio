#-------------------------------------------------------
# 変数の定義
#-------------------------------------------------------
variable "NameBase" {
  default = "sample01"
  type    = string
}
# 実行環境の管理タグ
variable "env" {
  default = "dev"
  type    = string
}
# RDSのインスタンスクラス
variable "InstanceClass" {
  default = "db.t2.micro"
}
# Mysqlのバージョン
variable "MysqlVession" {
  default = "8.0.28"
}
# マスターユーザーネーム
variable "Username" {
  default = "admin"
}
# マスターユーザーネーム
variable "rdspassword" {
  default = "4Ggf3wd&"
}
# ストレージ量
variable "Storage" {
  default = "20"
}
# 初期作成するDB名
variable "database_name" {}
# ストレージタイプ
variable "storage_type" {
  default = "gp2"
}
# サブネットIDの変数
variable "privatesubnet1a" {}
# サブネットIDの変数
variable "privatesubnet1b" {}
# RDSのsecuritygroup
variable "RDS_securitygroup" {}
# バックアップを保持する日数
variable "backup_retention_period" {
  default = "1"
}
