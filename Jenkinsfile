pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_LOG = 'INFO'
    }

    options {
        timeout(time: 15, unit: 'MINUTES') // Prevent infinite hangs
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                sh '''
                    echo "[INFO] Initializing Terraform"
                    terraform init -input=false

                    echo "[INFO] Applying Terraform"
                    terraform apply -auto-approve -input=false | tee terraform.log
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }

        stage('Run Container & Test') {
            steps {
                sh '''
                    docker run -d --name testcontainer -p 8080:8080 myapp

                    echo "[INFO] Waiting for app to respond..."
                    for i in {1..10}; do
                      sleep 2
                      if curl --silent http://localhost:8080; then
                        echo "[INFO] App is up!"
                        break
                      fi
                    done
                '''
            }
        }

        stage('Tear Down Container') {
            steps {
                sh 'docker rm -f testcontainer || true'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh '''
                    echo "[INFO] Destroying infrastructure"
                    terraform destroy -auto-approve -input=false | tee terraform-destroy.log
                '''
            }
        }
    }

    post {
        failure {
            echo '[ERROR] Pipeline failed. Check logs above for details.'
        }
        success {
            echo '[SUCCESS] Pipeline completed successfully!'
        }
    }
}
