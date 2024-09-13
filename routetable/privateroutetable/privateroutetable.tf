/*=== ROUTING TABLES AND ASSOCIATIONS ===*/
variable "vpc_id" {}
variable "nat_gateway_id1" {
}
variable "nat_gateway_id2" {
}

variable "subnet_id1" {
    
}

variable "subnet_id2" {
    
}

variable "env" { 
  default = "production" 
}

variable "project" {
  default = "america"
}

resource "aws_route_table" "privateroutetable-america-1" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${var.nat_gateway_id1}"
    }
    tags = {
        Name        = "privateroutetable-america-1"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_route_table_association" "privateroutetableassoc-1" {
    subnet_id      = "${var.subnet_id1}"
    route_table_id = "${aws_route_table.privateroutetable-america-1.id}"
}

resource "aws_route_table" "privateroutetable-america-2" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${var.nat_gateway_id2}"
    }
    tags = {
        Name        = "privateroutetable-america-2"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_route_table_association" "privateroutetableassoc-2" {
    subnet_id      = "${var.subnet_id2}"
    route_table_id = "${aws_route_table.privateroutetable-america-2.id}"
}

output "private_subnets_rt_ids" { 
 value = [
 "${aws_route_table.privateroutetable-america-1.id}"
,"${aws_route_table.privateroutetable-america-2.id}"] 
}