terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.0.4"
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "app_server" {
  count                  = 2
  ami                    = "ami-047e03b8591f2d48a"
  instance_type          = "t2.micro"
  key_name               = "ec2-deployer-key-pair"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "First-Ec2-With-Terraform"
  }
  connection {
    type    = "ssh"
    host    = self.public_ip
    user    = "ec2-user"
    timeout = "4m"
  }
}
resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}


