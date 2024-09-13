variable "vpc_id"{

}

variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}

variable "ansiblesg_id"{

}

resource "aws_security_group" "rds-sg-america" {
  name        = "rds-sg-america"
  description = "Allow inbound traffic from application layer"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ansiblesg_id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

output "rdssg_id" { 
  value = "${aws_security_group.rds-sg-america.id}"
}