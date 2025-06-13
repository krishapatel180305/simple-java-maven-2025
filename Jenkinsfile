pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token', branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Start Docker Container') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
