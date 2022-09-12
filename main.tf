resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_name_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc_name"
  }
}