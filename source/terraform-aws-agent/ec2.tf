resource "aws_instance" "build" {
  ami           = "${var.ec2["ami"]}"
  instance_type = "${var.ec2["instance_type"]}"

  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  key_name = "${aws_key_pair.generated_key.key_name}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${aws_instance.build.public_ip}"
      user        = "ubuntu"
      timeout     = "500s"
      private_key = "${tls_private_key.deploy_key.private_key_pem}"
    }

    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt update",
      "sudo apt install python -y",
    ]
  }

  tags = {
    Name = "${var.global["project"]}-BuildServer"
  }
}

resource "aws_instance" "prod" {
  ami           = "${var.ec2["ami"]}"
  instance_type = "${var.ec2["instance_type"]}"

  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  key_name = "${aws_key_pair.generated_key.key_name}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${aws_instance.prod.public_ip}"
      user        = "ubuntu"
      timeout     = "500s"
      private_key = "${tls_private_key.deploy_key.private_key_pem}"
    }

    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt update",
      "sudo apt install python -y",
    ]
  }

  tags = {
    Name = "${var.global["project"]}-ProdServer"
  }
}


