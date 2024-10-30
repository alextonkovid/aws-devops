# Private Instance with K3s Cluster
resource "aws_instance" "k3s_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.small"
  subnet_id       = aws_subnet.private_subnet_1.id
  key_name        = var.key_pair_name
  private_ip      = "10.0.3.60"
  security_groups = [aws_security_group.private_instance_sg.id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "k3s_instance"
  }
}

# NAT Instance
resource "aws_instance" "nat_instance" {
  ami               = data.aws_ami.nat.id
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.public_subnet_1.id
  key_name          = var.key_pair_name
  security_groups   = [aws_security_group.nat_sg.id]
  source_dest_check = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              service nginx start
              EOF

  tags = {
    Name = "nat_instance"
  }
}



# Elastic IP for NAT instance
resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
}