pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin"
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                sudo yum update -y
                sudo yum install -y docker git unzip || true
                sudo systemctl start docker || true
                sudo systemctl enable docker || true

                # Install Terraform
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
                sudo yum -y install terraform

                terraform --version
                docker --version
                '''
            }
        }

        stage('Checkout Repository') {
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
