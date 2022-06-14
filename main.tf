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
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  key_name               = "githubactions-aws-tf"
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

resource "aws_key_pair" "deployer" {
  key_name   = "githubactions-aws-tf"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSC4so+8P5hitID6g32gIM2yrYjvD06FrWtNw9AeXZ6cjpe60qG4DIsUsmauxVqXFITcCwEANADXRdtXZO30vT2Ic4nz1K6RQSp3Ih1LU8aoFBcwxInnCRPRKuJunimx9gfYVDie0XDWWnVRXrPHlbRSPC450kJsz/gyLS0GEtZtwyCUcmBhVrsn0Z0b13GZrOlzyi1g14og8UIl6k6ZuuKCMOCq0q0q+lhhHm+8lLK2rgN6q0jQw+QnuGrfiwZvr8WLh3CgDMjN/B5uvyanEuJOIBTx7fHlrrH/GUTT6wnAQjjTLsYBW+RxIwBEv2kweDKeTL/nqPDzZBPH5wmdbp"	
}
