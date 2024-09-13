module "provider"{
    source = "./provider"
}

module "vpc"{
    source = "./vpc"
    cidr = "10.0.0.0/16"
    domain_int = "america.L2"
}

module "cidr"{
    source = "./cidr"
    vpc_id = module.vpc.vpc_id
}

module "nat"{
    source = "./nat"
    vpc_id = module.vpc.vpc_id
    subnet_id1 = module.cidr.subnet_ids[2]
    subnet_id2 = module.cidr.subnet_ids[3]
}

module "igw"{
    source = "./igw"
    vpc_id = module.vpc.vpc_id
}

module "privateroutetable"{
    source = "./routetable/privateroutetable"
    vpc_id = module.vpc.vpc_id
    nat_gateway_id1 = module.nat.nat_gateway_ids[0]
    nat_gateway_id2 = module.nat.nat_gateway_ids[1]
    subnet_id1 = module.cidr.subnet_ids[2]
    subnet_id2 = module.cidr.subnet_ids[3]
}

module "publicroutetable"{
    source = "./routetable/publicroutetable"
    vpc_id = module.vpc.vpc_id
    igw = module.igw.igw[0]
    subnet_id3 = module.cidr.subnet_ids[0]
    subnet_id4 = module.cidr.subnet_ids[1]
}

module "ansible"{
    source = "./ansible"
    usrdataAnsibleMaster = "./Dependencies/userDataansiblemstr.sh"
    usrdataAnsibleNode = "./Dependencies/userDataansiblenode.sh"
    ssh_key_name = ""
    private_key_path = ""
    subnetid-ansiblemaster = module.cidr.subnet_ids[0]
    subnetid-ansiblenode = module.cidr.subnet_ids[2]
    ansible-sg-america = module.ansiblesg.ansiblesg_id
}

module "ansiblesg"{
    source = "./ansible/ansiblesg"
    vpc_id = module.vpc.vpc_id
}

module albsg{
    source = "./alb/albsg"
    vpc_id = module.vpc.vpc_id
}

module "alb"{
    source = "./alb"
    albsg_id = module.albsg.ansiblesg_id
    vpc_id = module.vpc.vpc_id
    ansible-master-america = module.ansible.ansible_ec2_ids[0]
    subnet_ids = [module.cidr.subnet_ids[0],module.cidr.subnet_ids[1]]
}






