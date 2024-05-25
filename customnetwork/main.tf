resource "aws_vpc" "devi" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC1"
  }
}

resource "aws_subnet" "devi" {
  vpc_id     = aws_vpc.devi.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "devi-pvt" {
  vpc_id     = aws_vpc.devi.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "pvt-subnet"
  }
}

resource "aws_internet_gateway" "devi" {
  vpc_id = aws_vpc.devi.id
  tags = {
    Name = "IG1"
  }
}

resource "aws_route_table" "devi" {
  vpc_id = aws_vpc.devi.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devi.id
  }
}

resource "aws_eip" "devi" {
  domain = "vpc"
}

resource "aws_nat_gateway" "devi" {
  allocation_id = aws_eip.devi.id
  subnet_id     = aws_subnet.devi.id
}

resource "aws_route_table" "devi-2" {
  vpc_id = aws_vpc.devi.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devi.id
  }
}

resource "aws_route_table_association" "devi-2" {
  subnet_id      = aws_subnet.devi-pvt.id
  route_table_id = aws_route_table.devi-2.id
}
resource "aws_route_table_association" "devi" {
  subnet_id      = aws_subnet.devi.id
  route_table_id = aws_route_table.devi.id
}

resource "aws_security_group" "devi" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.devi.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


# create instance
resource "aws_instance" "devi" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.devi.id
  key_name               = var.keyname
  vpc_security_group_ids = [aws_security_group.devi.id]

  tags = {
    Name = "ec2"
  }
}

resource "aws_instance" "devi-2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.devi-pvt.id
  key_name                    = var.keyname
  vpc_security_group_ids      = [aws_security_group.devi.id]
  associate_public_ip_address = false

  tags = {
    Name = "pvt-ec2"
  }
}