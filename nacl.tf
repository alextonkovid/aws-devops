# Create a Network ACL for Private Subnets
resource "aws_network_acl" "private_acl" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "private_acl"
  }
}

# Associate the Private Network ACL with Private Subnet 1
resource "aws_network_acl_association" "private_acl_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  network_acl_id = aws_network_acl.private_acl.id
}

# Associate the Private Network ACL with Private Subnet 2
resource "aws_network_acl_association" "private_acl_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  network_acl_id = aws_network_acl.private_acl.id
}

# Inbound Rule for Private Subnets (Allow All Traffic from VPC CIDR)
resource "aws_network_acl_rule" "private_inbound_vpc" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  egress         = false
}

# Outbound Rule for Private Subnets (Allow All Traffic)
resource "aws_network_acl_rule" "private_outbound" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}

# Create a Network ACL for Public Subnets
resource "aws_network_acl" "public_acl" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "public_acl"
  }
}

# Associate the Public Network ACL with Public Subnet 1
resource "aws_network_acl_association" "public_acl_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.public_acl.id
}

# Associate the Public Network ACL with Public Subnet 2
resource "aws_network_acl_association" "public_acl_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  network_acl_id = aws_network_acl.public_acl.id
}

# Outbound Rule for Public Subnets (Allow All Traffic)
resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public_acl.id
  rule_number    = 100
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}
