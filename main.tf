



#Subnet Group

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "app-rds-subnet-group"
  description = "Subne group for MySQL RDSinstance"
  subnet_ids = ["subnet-0699bc5a81d367c26", "subnet-01c90f35b30361faa", "subnet-0403b81548f0d59de"]
  tags = {
    Name = "app-rds-subnet-group"
    Environment = "dev"
    Project = "RDS Automation"
  }
}

#Security Group

resource "aws_security_group" "rds_sg" {
  name = "app-rds-sg"
  vpc_id = "vpc-045dd4ae40cafaf56"

  ingress {
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-rds-sg-group"
    Environment = "dev"
    Project = "RDS Automation"
  }
}

#RDS MYSQL Instance

resource "aws_db_instance" "mysql" {
  identifier = "app-mysql-db"
  engine = "mysql"
  engine_version = "8.0.43"
  instance_class = "db.t4g.micro"
  allocated_storage = 20
  storage_type = "gp2"
  db_name = "appdb"
  username = local.db_credentials.username
  password = local.db_credentials.password

  multi_az = true
  publicly_accessible = false

  backup_retention_period = 7
  
  skip_final_snapshot = true
  deletion_protection = false
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "app-mysql-db"
    Environment = "dev"
    Project = "RDS Automation"
  }
}