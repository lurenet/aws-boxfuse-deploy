variable "global" {
  type    = map
  default = {
    "project" = "boxfuse"
    "region"  = "eu-central-1"
    "zone"  = "a"
  }
}

variable "ec2" {
  type    = map
  default = {
    "ami"           = "ami-0b1deee75235aa4bb"  # Ubuntu 18.04 LTS
    "instance_type" = "t2.medium"
    "subnet_id"     = "subnet-0e325064" # zone-a
  }
}

variable "export" {
  type = map
  default =  {
    "host_options" = "ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/root/export/aws-private.pem"
    "app_name"     = "hello-1.0"
  }
}
