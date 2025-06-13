pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "nginx"
    TERRAFORM_DIR = "./terraform"
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
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
          docker build -t my-app .
          docker tag my-app ${DOCKER_IMAGE}
          docker push ${DOCKER_IMAGE}
        """
      }
    }
    stage('Deploy Container') {
      steps {
        sh "docker run -d -p 80:80 ${DOCKER_IMAGE}"
      }
    }
  }
}
