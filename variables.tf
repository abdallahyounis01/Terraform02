variable "region" {
    description = "region of aws"
    type = string
}

variable "cidr-block" {
    description = "cidr of vpc"
    type = string
}

variable "vpc-tag" {
    description = "name of vpc"
}

variable "sub" {
    description = "public and private subnets"
    type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
    id                = string
  }))
}

variable "internet-gateway" {
    description = "name of igw"
    type = string
}

variable "nat-gw" {
    description = "name of nat"
    type = string
}

variable "cidr-rt" {
    description = "cidr-block of route table"
    type = string
}



variable "tag_public" {
    description = "name of tag"
    type = string
}

variable "tag_private" {
    description = "name of tag"
    type = string
}

variable "security-group" {
    description = "name of security group" 
    type = string
}

variable "cidr-SG" {
    description = "cidar of sg"
    type = list(string)
}

variable "instances" {
  type = map(object({
    instance_type = string
    is_public     = bool
    subnet        = string
    user_data     = string
  }))
}
