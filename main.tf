provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQMNKFN3LYR5O66VV"
  secret_key = "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"
}

# ✅ Security Group: SSH + App Access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP (Tomcat)"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ✅ EC2 Instance with SSH Provisioning
resource "aws_instance" "build-server" {
  ami                         = "ami-000ec6c25978d5999"
  instance_type               = "t2.micro"
  key_name                    = "n-jenkins-v2"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/n-jenkins-v2.pem")
    host        = self.public_ip
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '[INFO] Waiting for EC2 readiness...'",
      "sleep 60",
      "echo '[INFO] Updating packages...'",
      "sudo yum update -y",
      "echo '[INFO] Installing Git, Java, Maven, Docker...'",
      "sudo yum install -y git java-11-openjdk-devel maven docker",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl start docker",
      "echo '[INFO] Downloading Tomcat...'",
      "curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz",
      "sudo tar -xzf apache-tomcat-9.0.78.tar.gz -C /opt/"
    ]
  }

  tags = {
    Name = "cicd-build-instance"
  }
}

# ✅ Output EC2 Public IP
output "instance_public_ip" {
  value = aws_instance.build-server.public_ip
}
