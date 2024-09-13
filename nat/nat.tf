/*=== NAT GW FOR THE PRIVATE SUBNETS ===*/
variable "name"  { default = "nat" }

variable "subnet_ids" {
    type    = list
    default = []
}

variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}

variable "vpc_id" {
  
}

variable "subnet_id1"{

}

variable "subnet_id2"{

}

resource "aws_eip" "natgweip-america-1" {
    tags = {
        Name = "natgweip-america-1"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_nat_gateway" "natgw-america-1" {
    allocation_id = "${aws_eip.natgweip-america-1.id}"
    subnet_id     = "${var.subnet_id1}"
    tags = {
        Name = "natgw-america-1"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_eip" "natgweip-america-2" {
    tags = {
        Name = "natgweip-america-2"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_nat_gateway" "natgw-america-2" {
    allocation_id = "${aws_eip.natgweip-america-2.id}"
    subnet_id     = "${var.subnet_id2}"
    tags = {
        Name = "natgw-america-2"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

output "nat_gateway_ids" { value = ["${aws_nat_gateway.natgw-america-1.id}","${aws_nat_gateway.natgw-america-2.id}"] }