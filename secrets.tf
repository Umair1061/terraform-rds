

#Read Credentials from AWS Secrets Manager
data "aws_secretsmanager_secret" "rds_db" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "rds_db_version" {
  secret_id = data.aws_secretsmanager_secret.rds_db.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_db_version.secret_string)
}