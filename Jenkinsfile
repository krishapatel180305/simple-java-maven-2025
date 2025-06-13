pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin"
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                sudo yum update -y || true
                sudo yum install -y docker git unzip || true
                sudo systemctl start docker || true
                sudo systemctl enable docker || true

                # Manually Install Terraform (No HashiCorp Repo)
                wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
                unzip terraform_1.6.6_linux_amd64.zip
                sudo mv terraform /usr/local/bin/
                terraform --version
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
