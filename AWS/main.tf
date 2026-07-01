# -----------------------------------
# VPC NETWORK
# -----------------------------------
resource "aws_vpc" "vpc_cp" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "vpc-cp"
    }
}   

# -----------------------------------
# VPC SUBNETS
# -----------------------------------

# -----------------------------------
# Public Subnet
# -----------------------------------
resource "aws_subnet" "cp_subnet_1" {
    vpc_id = aws_vpc.vpc_cp.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true

    tags = {
        Name = "cp-public-subnet"
    }
}

# -----------------------------------
# Private Subnet
# -----------------------------------
resource "aws_subnet" "cp_subnet_2" {
    vpc_id = aws_vpc.vpc_cp.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}b"

    tags = {
        Name = "cp-private-subnet"
    }
}

# -----------------------------------
# Internet Gateway
# -----------------------------------
resource "aws_internet_gateway" "cp_igw" {
    vpc_id = aws_vpc.vpc_cp.id

    tags = {
      Name = "cp-igw"
    }
}

# -----------------------------------
# Route Tables
# -----------------------------------
resource "aws_route_table" "cp_route_table" {
    vpc_id = aws_vpc.vpc_cp.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cp_igw.id
    }

    tags = {
        Name = "cp-route-table"
    }
}

# -----------------------------------
# Route Tables Association
# -----------------------------------
resource "aws_route_table_association" "cp_rta" {
    subnet_id = aws_subnet.cp_subnet_1.id
    route_table_id = aws_route_table.cp_route_table.id
}

# -----------------------------------
# Security Groups
# -----------------------------------
resource "aws_security_group" "cp_asg" {
  vpc_id = aws_vpc.vpc_cp.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cp-asg"
  }
}

# ----------------------------------
# EC2 INSTANCE
# ----------------------------------
data "aws_ami" "ubuntu" {
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

resource "aws_instance" "cp_ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.cp_subnet_1.id
  vpc_security_group_ids = [aws_security_group.cp_asg.id]
  key_name = aws_key_pair.cp_akp.key_name

  tags = {
    Name = "cp-ec2-instance"
  }
}

resource "aws_key_pair" "cp_akp" {
    key_name = "cp-key-pair"
    public_key = file(var.ssh_key_path)
}