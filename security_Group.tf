resource "aws_security_group" "mysg" {
  tags = {
    Name = "my-SG"
  }
  name        = "Terraform-Sg"
  description = "it has all Traffic"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
