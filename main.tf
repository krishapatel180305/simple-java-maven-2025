provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "build-server" {
  ami                         = "ami-000ec6c25978d5999" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = "n-jenkins" # This must exactly match the key name you created in AWS
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/n-jenkins.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git java-11-openjdk-devel maven docker",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl start docker",
      "curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz",
      "sudo tar -xzf apache-tomcat-9.0.78.tar.gz -C /opt/"
    ]
  }

  tags = {
    Name = "cicd-build-instance"
  }
}
