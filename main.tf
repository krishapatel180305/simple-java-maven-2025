provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Tf-instance" {
  ami           = "ami-0f3f13f145e66a0a3"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-CI-CD-Instance"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Defaults:ec2-user !requiretty' | sudo tee -a /etc/sudoers",
      "sudo yum update -y",
      "sudo yum install -y docker git java-11-openjdk",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my-key.pem")
    host        = self.public_ip
  }
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.Tf-instance.public_ip
}
