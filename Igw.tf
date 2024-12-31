resource "aws_internet_gateway" "myigw" {
  tags = {
    Name = "My_IGW"
  }
  vpc_id = aws_vpc.myvpc.id

}