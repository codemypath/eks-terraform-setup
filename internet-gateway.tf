resource "aws_internet_gateway" "main" {
  # get vpc id dynamically so in case that vpc_id changes internet-gateway will have new vpc_id without any manual change
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# output "test_id"{
#     value = aws_internet_gateway.main.vpc_id
# }