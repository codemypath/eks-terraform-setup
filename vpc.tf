resource "aws_vpc" "main" {
  # cidr block for VPC
  cidr_block = "192.168.0.0/16"
  # instance tenancy is 'default' by default but in case that 'dedicated' becomes default in some moment we want to avoid extra charges
  instance_tenancy = "default"
  # required for EKS, default is true but still defining it in case that default value changes
  enable_dns_support = true
  # required for EKS, default is false
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

# output "vpc_id" {
#   value       = aws_vpc.main.id
#   description = "VPC id"
#   sensitive   = false
# }