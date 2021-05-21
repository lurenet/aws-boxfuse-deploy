resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.global["project"]}-Key"
  public_key = "${tls_private_key.deploy_key.public_key_openssh}"
}
