provider "aws" {
  region = "us-east-1"  # Change to your desired region
  access_key = AKIAQMNKFN3L6OJW7EIQ
  secret_key = lfTJQdhqsaLS1AmAzRrQdRSN4g46SGU58DRUcIZt
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0947d2ba12ee1ff75"  # Amazon Linux 2 AMI (ensure it's correct for your region)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker git
    sudo systemctl enable docker && sudo systemctl start docker
    sudo docker run -d -p 80:80 --name nginx-container nginx
  EOF

  tags = {
    Name = "Terraform-Automated-Instance"
  }
}

output "instance_ip" {
  value = aws_instance.jenkins_server.public_ip
}
