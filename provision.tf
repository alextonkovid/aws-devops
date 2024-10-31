resource "terraform_data" "bootstrap-k3s" {
  triggers_replace = [aws_instance.k3s_instance.id]

  connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = ${{ secrets.SSH_PRIVATE_KEY }}
    host                = aws_instance.k3s_instance.private_ip
    bastion_host        = aws_eip.nat_eip.public_ip
    bastion_user        = "ec2-user"
    bastion_private_key = ${{ secrets.SSH_PRIVATE_KEY }}
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

  provisioner "local-exec" {
    command = "bash data/copy-kube-conf.sh"

    environment = {
      PRIVATE_INSTANCE_IP = aws_instance.k3s_instance.private_ip
      BASTION_HOST_IP     = aws_eip.nat_eip.public_ip
    }
  }
}

resource "terraform_data" "bootstrap-bastion" {
  triggers_replace = [aws_instance.nat_instance.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = ${{ secrets.SSH_PRIVATE_KEY }}
    host        = aws_eip.nat_eip.public_ip
  }

  provisioner "file" {
    source      = "data/nginx/"
    destination = "/tmp"
  }



  provisioner "local-exec" {
    command = "ssh -tt ec2-user@$BASTION_HOST_IP \"sudo bash /tmp/config-nginx.sh\""

    environment = {
      BASTION_HOST_IP = aws_eip.nat_eip.public_ip
    }
  }

}
