resource "terraform_data" "bootstrap-k3s" {
  triggers_replace = [aws_instance.k3s_instance.id]

  connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = var.ssh_private_key
    host                = aws_instance.k3s_instance.private_ip
    bastion_host        = aws_eip.nat_eip.public_ip
    bastion_user        = "ec2-user"
    bastion_private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = "data"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/data/bootstrap-k3s.sh",
      "/tmp/data/bootstrap-k3s.sh args",
    ]
  }
  # For local configs copy

  # provisioner "local-exec" {
  #   command = "bash data/copy-kube-conf.sh"

  #   environment = {
  #     PRIVATE_INSTANCE_IP = aws_instance.k3s_instance.private_ip
  #     BASTION_HOST_IP     = aws_eip.nat_eip.public_ip
  #   }
  # }
}

resource "terraform_data" "bootstrap-bastion" {
  triggers_replace = [aws_instance.nat_instance.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.ssh_private_key
    host        = aws_eip.nat_eip.public_ip
  }

  provisioner "file" {
    source      = "data/nginx/"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/config-nginx.sh",
      "/tmp/config-nginx.sh args",
    ]
  }

}
