variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}

variable "vpc_id" {
  
}

resource "aws_internet_gateway" "igw-america" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "igw-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

output "igw" { 
value = [
 "${aws_internet_gateway.igw-america.id}"
] 
}