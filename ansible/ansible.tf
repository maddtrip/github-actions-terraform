variable "subnetid-ansiblemaster"{

}

variable "subnetid-ansiblenode"{

}

variable "ansible-sg-america"{
  
}

variable "ssh_key_name"{
  
}

variable "private_key_path"{
  
}

variable "usrdataAnsibleMaster"{

}

variable "usrdataAnsibleNode"{

}

variable "project" {
  default = "america"
}
variable "env" {
  default = "production"
}



resource "aws_instance" "ansible-master-america" {
  ami = "${data.aws_ami.aws-linux.id}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnetid-ansiblemaster}"
  vpc_security_group_ids = ["${var.ansible-sg-america}"]
  key_name               = var.ssh_key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
  tags = {
    Name = "ansible-master-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }
  # User data script to install Ansible
  user_data = base64encode("${file(var.usrdataAnsibleMaster)}")
}

# Creating 2nd EC2 instance in Public Subnet
resource "aws_instance" "ansible-node-america" {
  ami = data.aws_ami.aws-linux.id
  instance_type = "t2.micro"
  subnet_id = "${var.subnetid-ansiblenode}"
  vpc_security_group_ids = ["${var.ansible-sg-america}"]
  key_name               = var.ssh_key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
  tags = {
    Name = "ansible-node-america"
    Environment = lower(var.env)
    Project = lower(var.project)
  }

  # User data script to install Ansible
  user_data = base64encode("${file(var.usrdataAnsibleNode)}")
}


data "aws_ami" "aws-linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "ansible_ec2_ids" { 
  value = [
 "${aws_instance.ansible-master-america}"
,"${aws_instance.ansible-node-america}"] 
}