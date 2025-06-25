pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Terraform Apply') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }

        stage('Run Container & Test') {
            steps {
                sh 'docker run -d --name testcontainer -p 8080:8080 myapp'
                sh 'sleep 20'
                sh 'curl http://localhost:8080 || echo "App may not be reachable"'
            }
        }

        stage('Tear Down Container') {
            steps {
                sh 'docker rm -f testcontainer || true'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
