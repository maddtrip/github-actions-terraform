variable "database-subnetid1"{

}
variable "database-subnetid2"{
  
}

variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}

variable "rdssg_id"{

}

# Creating RDS Instance
resource "aws_db_subnet_group" "rdssubnet-america-1" {
  name       = "main"
  subnet_ids = [var.database-subnetid2, var.database-subnetid1]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "rds-america-1" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.rdssubnet-america-1.id
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  multi_az               = true
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [rdssg_id]
}