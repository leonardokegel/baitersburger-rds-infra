resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.nets.ids
}

resource "aws_security_group" "rds_public" {
  name        = "rds-public-sg"
  description = "Allow public access to RDS"
  vpc_id      = data.aws_vpc.vpc_default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mysql" {
  identifier         = "baitersburger-mysql"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20

  username = local.rds_secret.username
  password = local.rds_secret.password
  db_name  = local.rds_secret.db_name

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_public.id]

  publicly_accessible     = true
  skip_final_snapshot     = true
  deletion_protection     = false
  iam_database_authentication_enabled = false

  tags = {
    Project = "baitersburger"
    Service = "customer"
  }
}