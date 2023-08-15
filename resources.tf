resource "aws_vpc" "sprints_vpc" {
  cidr_block       = var.cidr-block
  tags = {
    Name = var.vpc-tag
  }
}

#resource of elestic ip
resource "aws_eip" "eip" {
  domain = "vpc"
}

#resource of nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnets["public-subnet"].id

  tags = {
    Name = var.nat-gw
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sprints_vpc.id

  tags = {
    Name = var.internet-gateway
  }
}

resource "aws_subnet" "subnets" {
    for_each = var.sub
  vpc_id            = aws_vpc.sprints_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.value.name
  }
}
#Route table of public
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sprints_vpc.id

  route {
    cidr_block = var.cidr-rt
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.tag_public
  }
}

#Resource:route table association for public
resource "aws_route_table_association" "rt_public" {
  subnet_id      = aws_subnet.subnets["public-subnet"].id
  route_table_id = aws_route_table.public_rt.id
}




#Route table of private
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.sprints_vpc.id

  route {
    cidr_block = var.cidr-rt
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.tag_private
  }
}

#Resource:route table association for private
resource "aws_route_table_association" "rt_a" {
  subnet_id      = aws_subnet.subnets["private-subnet"].id
  route_table_id = aws_route_table.private_rt.id
}



resource "aws_security_group" "sg" {
  name   = var.security-group
  vpc_id = aws_vpc.sprints_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =  var.cidr-SG
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr-SG
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr-SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.cidr-SG
  }

}
data "aws_ami" "amazon_ec2" {
      most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical 
}

resource "aws_instance" "ec2" {
  for_each      = var.instances
  ami           = data.aws_ami.amazon_ec2.image_id
  instance_type = each.value.instance_type
  subnet_id = aws_subnet.subnets[each.value.subnet].id  #value.subnet-->subnet in values.auto in instance and will do loop back with each.value
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  user_data = each.value.user_data

  tags = {
    Name = "${each.key}"
  }
}
