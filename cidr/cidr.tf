
variable "env" { 
  default = "production" 
}

variable "vpc_id" {

}


variable "subnet_cidr"{
  default = "10.0.1.0/24"
}

variable "subnet1_cidr" {
  default = "10.0.2.0/24"
}

variable "subnet2_cidr" {
  default = "10.0.3.0/24"
}

variable "subnet3_cidr" {
  default = "10.0.4.0/24"
}

variable "subnet4_cidr" {
  default = "10.0.5.0/24"
}

variable "subnet5_cidr" {
  default = "10.0.6.0/24"
}

variable "project" {
  default = "america"
}



resource "aws_subnet" "public-subnet-america-1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block             = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name        = "public-subnet-america-1"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_subnet" "public-subnet-america-2" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block             = "${var.subnet1_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name        = "public-subnet-america-2"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}


resource "aws_subnet" "application-subnet-america-1" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block             = "${var.subnet2_cidr}"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
    Name        = "application-subnet-america-1"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_subnet" "application-subnet-america-2" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block             = "${var.subnet3_cidr}"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    Name        = "application-subnet-america-2"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_subnet" "database-subnet-america-1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnet4_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "database-subnet-america-1"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_subnet" "database-subnet-america-2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnet5_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "database-subnet-america-2"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}



output "subnet_ids" { 
value = [
 "${aws_subnet.public-subnet-america-1.id}"
,"${aws_subnet.public-subnet-america-2.id}"
,"${aws_subnet.application-subnet-america-1.id}"
,"${aws_subnet.application-subnet-america-2.id}"
,"${aws_subnet.database-subnet-america-1.id}"
,"${aws_subnet.database-subnet-america-1.id}"
] 
}