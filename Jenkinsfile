pipeline {
    agent any
    environment {
        TERRAFORM_DIR = "terraform"
        DOCKER_IMAGE = "nginx"
    }
    stages {
        stage('Workspace Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Setup Environment') {
            steps {
                sh """
                    echo 'Installing Terraform...'
                    sudo yum install -y unzip git java-11-openjdk
                    wget -qO terraform.zip https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
                    sudo unzip -o terraform.zip -d /usr/local/bin
                    terraform version
                """
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
                sh """
                    echo "Verifying Terraform directory..."
                    ls -l
                    [ -d ${env.TERRAFORM_DIR} ] || { echo "ERROR: Terraform directory does not exist!"; exit 1; }
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    if [ ! -d "${env.TERRAFORM_DIR}" ]; then
                        echo "ERROR: Terraform directory does not exist!"
                        exit 1
                    fi

                    cd ${env.TERRAFORM_DIR}
                    terraform init
                    terraform apply -auto-approve
                """
                script {
                    env.INSTANCE_IP = sh(script: "cd terraform && terraform output -raw instance_public_ip", returnStdout: true).trim()
                    if (!env.INSTANCE_IP) error "Failed to retrieve EC2 instance IP!"
                }
            }
        }

        stage('Install Dependencies on EC2') {
            steps {
                sh """
                    echo "Installing Docker, Terraform, Git, and Java on ${env.INSTANCE_IP}..."
                    ssh -i ~/.ssh/my-key.pem -o StrictHostKeyChecking=no ec2-user@${env.INSTANCE_IP} <<EOF
                        sudo yum update -y
                        sudo yum install -y docker git java-11-openjdk
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        echo "Installation complete!"
                    EOF
                """
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh """
                    echo "Deploying Docker on ${env.INSTANCE_IP}..."
                    ssh -i ~/.ssh/my-key.pem -o StrictHostKeyChecking=no ec2-user@${env.INSTANCE_IP} <<EOF
                        sudo docker run -d -p 80:80 ${env.DOCKER_IMAGE}
                        echo 'Docker container deployment successful!'
                    EOF
                """
            }
        }
    }
}
