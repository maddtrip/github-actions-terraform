variable "name" {
  default = "vpc-america"
}

variable "cidr" {}
variable "domain_int" {}
variable "env" { 
    default = "production" 
    }

variable project{
  default = "america"
}

/*=== VPC AND GATEWAYS ===*/
resource "aws_vpc" "vpc-america" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.name}"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_internet_gateway" "igw-america" {
  vpc_id = aws_vpc.vpc-america.id
  tags = {
    Name        = "igw-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

/*=== DHCP AND DNS ===*/
resource "aws_route53_zone" "route53-america" {
  name   = "america.${var.domain_int}"
}

resource "aws_route53_record" "route53record-america" {
  zone_id = aws_route53_zone.route53-america.zone_id
  name    = "america.${var.domain_int}"
  type    = "NS"
  ttl     = "30"
  records = [
    "${aws_route53_zone.route53-america.name_servers.0}",
    "${aws_route53_zone.route53-america.name_servers.1}",
    "${aws_route53_zone.route53-america.name_servers.2}",
    "${aws_route53_zone.route53-america.name_servers.3}"
  ]
}

/* Not needed here since the zone is being associated with
   the VPC via vpc_id upon creation
resource "aws_route53_zone_association" "environment" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  vpc_id  = "${aws_vpc.environment.id}"
}
*/

resource "aws_vpc_dhcp_options" "dhcpoptions-america" {
  domain_name         = ""
  domain_name_servers = ["169.254.169.253", "AmazonProvidedDNS"]
  tags = {
    Name        = "dhcp-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
}

resource "aws_vpc_dhcp_options_association" "dhcpassoc-america" {
  vpc_id          = aws_vpc.vpc-america.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcpoptions-america.id
}

output "vpc_id" { value = aws_vpc.vpc-america.id }
output "igw_id" { value = aws_internet_gateway.igw-america.id }
output "route53_zone" { value = aws_route53_zone.route53-america.id }
output "vpc_cidr" { value = aws_vpc.vpc-america.cidr_block }
