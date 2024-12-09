

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "my_ec2_key_pair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}


resource "aws_instance" "public_ec2_az1" {
  ami           = var.ami

  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_az1_id
  security_groups = [var.pub_security_group_id]
  key_name = aws_key_pair.ec2_key_pair.key_name



  

  tags = {
    Name = "${var.project_name}-public_ec2_az1"

  }
user_data = <<-EOF
          #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip python3-six

            EOF

}


resource "aws_instance" "public_ec2_az2" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_az2_id
  security_groups = [var.pub_security_group_id]
  key_name = aws_key_pair.ec2_key_pair.key_name


  tags = {
    Name = "${var.project_name}-public_ec2_az2"

  }
user_data = <<-EOF
          #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip


            EOF
  
}


resource "aws_instance" "private_ec2_az1" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_az1_id
  security_groups = [var.priv_security_group_id]
  key_name = aws_key_pair.ec2_key_pair.key_name



  tags = {
    Name = "${var.project_name}-private_ec2_az1"

  }

  user_data = <<-EOF
          #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip
         

            
            EOF
}


resource "aws_instance" "private_ec2_az2" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_az2_id
  security_groups = [var.priv_security_group_id]
  key_name = aws_key_pair.ec2_key_pair.key_name


  tags = {
    Name = "${var.project_name}-private_ec2_az2"

  }
    user_data = <<-EOF
          #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip
      

            EOF
}


