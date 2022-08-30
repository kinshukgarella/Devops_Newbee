output "private1_subnet_id" {
    value = "${aws_subnet.private_1.id}"
}

output "private2_subnet_id" {
    value = "${aws_subnet.private_2.id}"
}

output "public1_subnet_id" {
    value = "${aws_subnet.public_1.id}"
}

output "public2_subnet_id" {
    value = "${aws_subnet.public_2.id}"
}