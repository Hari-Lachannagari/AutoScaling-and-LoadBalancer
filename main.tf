resource "aws_launch_template" "mylt" {
  name                   = "terraform-lt"
  description            = "v1"
  image_id               = "ami-0ca9fb66e076a6e32"
  instance_type          = "t2.micro"
  key_name               = "Harikeypair"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  user_data              = base64encode(<<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl restart httpd
    sudo chmod 766 /var/www/html/index.html
    echo "<html><body><h1>Welcome to Terraform Scaling.</h1></body></html>" >/var/www/html/index.html
  EOF
  )
}

resource "aws_elb" "myelb" {
  name            = "terraform-asg-elb"
  security_groups = [aws_security_group.mysg.id]
  subnets         = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}

resource "aws_autoscaling_group" "myasg" {
  name                = "terraform-asg"
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2
  health_check_type   = "EC2"
  load_balancers      = [aws_elb.myelb.name]
  vpc_zone_identifier = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]

  launch_template {
    id      = aws_launch_template.mylt.id
    version = "$Latest"
  }
}
