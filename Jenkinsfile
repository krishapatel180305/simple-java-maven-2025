pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "nginx"
        TERRAFORM_DIR = "terraform"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',  url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
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
                    if [ -d "${TERRAFORM_DIR}" ]; then
                        cd ${TERRAFORM_DIR}
                        terraform init
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan
                    else
                        echo "ERROR: Terraform directory does not exist!"
                        exit 1
                    fi
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
