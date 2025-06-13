pipeline {
    agent any
    environment {
        TERRAFORM_DIR = "terraform"
        DOCKER_IMAGE = "nginx"
    }
    stages {
        stage('Setup Environment') {
            steps {
                sh """
                    echo 'Installing Maven & Terraform on Amazon Linux 2...'
                    
                    # Install Maven
                    sudo -E yum update -y
                    sudo -E yum install -y maven
                    
                    # Verify Maven installation
                    mvn -version
                    
                    # Install Terraform
                    sudo -E yum install -y unzip
                    wget -qO terraform.zip https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
                    sudo -E unzip terraform.zip -d /usr/local/bin
                    terraform version
                    
                    echo 'Installation complete!'
                """
            }
        }
        
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
            }
        }

        stage('Terraform Apply - Create EC2') {
            steps {
                sh """
                    cd ${TERRAFORM_DIR}
                    terraform init
                    terraform plan -out=tfplan
                    terraform apply -auto-approve tfplan
                    
                    # Capture instance IP
                    INSTANCE_IP=$(terraform output -raw public_ip)
                    echo "AWS EC2 Instance Created: $INSTANCE_IP"
                """
            }
        }

        stage('Deploy Docker on EC2') {
            steps {
                sh """
                    INSTANCE_IP=$(terraform output -raw public_ip)
                    
                    echo "Connecting to EC2 instance..."
                    
                    ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP <<EOF
                        sudo yum update -y
                        sudo yum install -y docker
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        sudo docker pull ${DOCKER_IMAGE}
                        sudo docker run -d -p 80:80 ${DOCKER_IMAGE}
                        echo 'Docker container deployed successfully!'
                    EOF
                """
            }
        }
    }
}
