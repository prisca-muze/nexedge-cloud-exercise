output "vpc_id" {
  description = "The ID of the AWS VPC."
  value       = aws_vpc.vpc_cp.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet."
  value       = aws_subnet.cp_subnet_1.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet."
  value       = aws_subnet.cp_subnet_2.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway."
  value       = aws_internet_gateway.cp_igw.id
}

output "route_table_id" {
  description = "The ID of the route table."
  value       = aws_route_table.cp_route_table.id
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = aws_security_group.cp_asg.id
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.cp_ec2_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.cp_ec2_instance.public_ip
}

output "key_pair_name" {
  description = "The name of the AWS key pair created."
  value       = aws_key_pair.cp_akp.key_name
}
