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
                    echo 'Installing Terraform...'
            sudo yum install -y unzip
            
            # Download Terraform
            wget -qO terraform.zip https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
            
            # Force overwrite existing Terraform binary
            sudo unzip -o terraform.zip -d /usr/local/bin
            
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
                    if [ -d "${env.TERRAFORM_DIR}" ]; then
                        cd "${env.TERRAFORM_DIR}"
                        terraform init
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan
                    else
                        echo "ERROR: Terraform directory does not exist!"
                        exit 1
                    fi
                """

                script {
                    def instanceIp = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
                    env.INSTANCE_IP = instanceIp
                    echo "AWS EC2 Instance Created: ${env.INSTANCE_IP}"
                }
            }
        }

        stage('Deploy Docker on EC2') {
            steps {
                script {
                    if (env.INSTANCE_IP) {
                        sh """
                            echo "Connecting to EC2 instance at ${env.INSTANCE_IP}..."
                            ssh -o StrictHostKeyChecking=no ec2-user@${env.INSTANCE_IP} <<EOF
                                sudo yum update -y
                                sudo yum install -y docker
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                sudo docker pull ${env.DOCKER_IMAGE}
                                sudo docker run -d -p 80:80 ${env.DOCKER_IMAGE}
                                echo 'Docker container deployed successfully!'
                            EOF
                        """
                    } else {
                        error "Instance IP not found! Terraform may have failed."
                    }
                }
            }
        }
    }
}
