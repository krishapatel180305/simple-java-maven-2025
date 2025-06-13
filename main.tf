provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Tf-instance" {
  ami           = "ami-0f3f13f145e66a0a3"
  instance_type = "t2.micro"
}
