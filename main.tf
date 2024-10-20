# Private Instance with K3s Cluster
resource "aws_instance" "k3s_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium" # Increased instance size for k3s cluster
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = var.key_pair_name
  security_groups = [aws_security_group.private_instance_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
  EOF
  
  tags = {
    Name = "k3s_instance"
  }
}

# Output the private instance public DNS (for SSH access through Bastion)
output "k3s_instance_public_ip" {
  value = aws_instance.k3s_instance.public_dns
}

# Deploying Prometheus and Grafana in K3s
resource "null_resource" "deploy_prometheus_grafana" {
  depends_on = [aws_instance.k3s_instance]

  provisioner "remote-exec" {
    inline = [
      "sudo snap install helm --classic && export KUBECONFIG=/etc/rancher/k3s/k3s.yaml",
      "git clone https://github.com/cablespaghetti/k3s-monitoring.git",
      "cd k3s-monitoring",
      "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts",
      "helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --version 39.13.3 --values kube-prometheus-stack-values.yaml",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host        = aws_instance.k3s_instance.private_ip
      bastion_host = aws_eip.nat_eip.public_ip # Using bastion host for SSH
      bastion_user = "ec2-user"
      bastion_private_key = file("~/.ssh/id_ed25519")
    }
  }
}

# Deploying Simple Pod Workload
resource "null_resource" "deploy_simple_pod" {
  depends_on = [aws_instance.k3s_instance]

  provisioner "remote-exec" {
    inline = [
      "sudo kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host        = aws_instance.k3s_instance.private_ip
      bastion_host = aws_eip.nat_eip.public_ip # Using bastion host for SSH
      bastion_user = "ec2-user"
      bastion_private_key = file("~/.ssh/id_ed25519")
    }
  }
}


# NAT Instance
resource "aws_instance" "nat_instance" {
  ami             = data.aws_ami.nat.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1.id
  key_name        = var.key_pair_name
  security_groups = [aws_security_group.nat_sg.id]
  source_dest_check = false

  tags = {
    Name = "nat_instance"
  }
}


# Elastic IP for NAT instance
resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
}