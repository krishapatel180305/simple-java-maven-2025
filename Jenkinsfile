pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "nginx"
        TERRAFORM_DIR = "terraform"
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

        stage('Build & Test') {
            steps {
                sh """
                    mvn clean package
                    java -jar target/*.jar
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    cd ${TERRAFORM_DIR}
                    terraform init
                    terraform plan -out=tfplan
                    terraform apply -auto-approve tfplan
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE} .
                    docker push ${DOCKER_IMAGE}
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                    docker run -d -p 80:80 --name my-app ${DOCKER_IMAGE}
                """
            }
        }
    }
}
