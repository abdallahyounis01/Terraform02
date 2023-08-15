region = "us-east-1"

cidr-block = "10.0.0.0/16"

vpc-tag = "sprints"

sub= {
    "public-subnet" = {
        cidr_block = "10.0.0.0/24"
        availability_zone = "us-east-1a"
        name = "public-Sub"
        id = "subnet-0123456789abcdef0"
    },
    "private-subnet" = {
        cidr_block = "10.0.1.0/24"
        availability_zone = "us-east-1a"
        name = "private-Sub"
        id = "subnet-0123456789abcdef1"
    }
}

internet-gateway = "sprints-igw"

nat-gw = "sprints-NAT"

cidr-rt = "0.0.0.0/0"


tag_public = "public RT"

tag_private = "private RT"


security-group = "sprints SG"

cidr-SG = ["0.0.0.0/0"]

instances = {
    public-instance = {
      instance_type = "t2.micro"
      is_public     = true
      subnet        = "public-subnet"
      user_data     = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get -y install apache2
  systemctl status apache2
  systemctl start apache2
  echo "<html><body><h1>Hello from Apache2</h1></body></html>" > /var/www/html/index.html
EOF
    }
    private-instance = {
      instance_type = "t2.micro"
      is_public     = false
      subnet        = "private-subnet"
      user_data     = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get -y install apache2
  systemctl status apache2
  systemctl start apache2
  echo "<html><body><h1>Hello from Apache2</h1></body></html>" > /var/www/html/index.html
EOF
    }
}



