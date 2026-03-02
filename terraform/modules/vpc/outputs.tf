output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_2a_id" {
  value = aws_subnet.public_2a.id
}

output "public_subnet_2b_id" {
  value = aws_subnet.public_2b.id
}

output "private_subnet_2a_id" {
  value = aws_subnet.private_2a.id
}

output "private_subnet_2b_id" {
  value = aws_subnet.private_2b.id
}
