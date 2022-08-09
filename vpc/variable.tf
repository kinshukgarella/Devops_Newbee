variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "Vpc-custom"
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1"
  type = string
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2"
  type = string
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1"
  type = string
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2"
  type = string
}

variable "default_subnet" {
  description = "Default Subnet 0.0.0.0/0"
  type = string
}