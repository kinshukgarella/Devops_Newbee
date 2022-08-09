/*output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.vpc_cidr_block.id
}

output "private_subnet_1_id" {
    description = "Private Subnet 1 ID"
    value = data.aws_subnet_ids.private_1.ids
}
output "private_subnet_2_id" {
    description = "Private Subnet 2 ID"
    value = data.aws_subnet_ids.private_2.ids
}
output "public_subnet_1_id" {
    description = "Public Subnet 1 ID"
    value = data.aws_subnet_ids.public_1.id
}
output "public_subnet_2_id" {
    description = "Public Subnet 2 ID"
    value = data.aws_subnet_ids.public_2.id
}
*/
output "ec2_subnet_id" {
    value = aws_subnet.private_1.id
}