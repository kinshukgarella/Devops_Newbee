provider "aws" {
#    web_region = var.web_region
    access_key = var.access_key
    secret_key = var.secret_key
  
}

module "vpc" {
    source = ".//vpc"
    private_subnet_1_cidr = var.private_subnet_1_cidr
    private_subnet_2_cidr = var.private_subnet_2_cidr
    public_subnet_1_cidr = var.public_subnet_1_cidr
    public_subnet_2_cidr = var.public_subnet_2_cidr
    vpc_cidr = var.vpc_cidr
    default_subnet = var.default_subnet
    
}
module "s3" {
    source = ".//s3"
    s3_bucket = var.s3_bucket
    web_region = var.web_region
}
module "ecr" {
    source = ".//ecr"
    repo_name = var.repo_name
    web_region = var.web_region
 
}
module "ec2" {
    source = ".//ec2"
    ec2_count = var.ec2_count
    ami_id = var.ami_id
    instance_type = var.instance_type
    subnet_id = "${module.vpc.private1_subnet_id}"
}

module "eks" {
    source = ".//eks"
    subnet_id_1 = "${module.vpc.public1_subnet_id}"
    subnet_id_2 = "${module.vpc.public2_subnet_id}"
    web_region = var.web_region
}