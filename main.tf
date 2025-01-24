resource "aws_vpc" "space_station_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "space_station_subnet" {
  vpc_id                  = aws_vpc.space_station_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "space_station_sg" {
  vpc_id = aws_vpc.space_station_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["205.206.78.63/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "space_station_ec2" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t2.small"
  key_name        = "eks-pair"
  subnet_id       = aws_subnet.space_station_subnet.id
  security_groups = [aws_security_group.space_station_sg.name]

  tags = {
    Name = "SpaceStationEC2"
  }
}
