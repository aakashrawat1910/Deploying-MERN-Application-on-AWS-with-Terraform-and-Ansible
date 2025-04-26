resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [var.web_security_group_id]
  iam_instance_profile   = var.instance_profile_name

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nodejs npm
              EOF

  tags = {
    Name        = "web-server"
    Environment = var.environment
  }
}

resource "aws_instance" "database" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [var.db_security_group_id]
  iam_instance_profile   = var.instance_profile_name

  tags = {
    Name        = "database-server"
    Environment = var.environment
  }
}