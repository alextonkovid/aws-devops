# NAT Instance Security Group
resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  vpc_id      = aws_vpc.main_vpc.id
  description = "Allow inbound SSH and outbound traffic to the internet"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.ingress_cidr
  }
  ingress {
    from_port   = var.ingress_ports.from_port
    to_port     = var.ingress_ports.to_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr
  }

  tags = {
    Name = "nat_sg"
  }
}

# Security Group for Instances in Private Subnet
resource "aws_security_group" "private_instance_sg" {
  name   = "private_instance_sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = var.ingress_ports.from_port
    to_port     = var.ingress_ports.to_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr
  }

  tags = {
    Name = "private_instance_sg"
  }
}
