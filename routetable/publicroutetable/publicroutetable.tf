/*=== ROUTING TABLES AND ASSOCIATIONS ===*/
variable "igw"   {}
variable "vpc_id" {}
variable "subnet_id3" {
    
}

variable "subnet_id4" {
    
}

variable "env" { 
  default = "production" 
}

variable "project" {
  default = "america"
}

resource "aws_route_table" "publicroutetable-america-1" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.igw}"
    }
    tags = {
        Name        = "publicroutetable-america-1"
        Environment = lower(var.env)
        Project = lower(var.project)
    }
}

resource "aws_route_table_association" "publicroutetableassoc-america-1" {
    subnet_id      = "${var.subnet_id3}"
    route_table_id = "${aws_route_table.publicroutetable-america-1.id}"
}

resource "aws_route_table_association" "publicroutetableassoc-america-2" {
    subnet_id      = "${var.subnet_id4}"
    route_table_id = "${aws_route_table.publicroutetable-america-1.id}"
}

output "public_subnets_rt_ids" { 
 value = [
 "${aws_route_table.publicroutetable-america-1.id}"
] 
}