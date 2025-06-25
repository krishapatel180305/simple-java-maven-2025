pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                sh '''
                    echo "[INFO] Initializing Terraform"
                    terraform init

                    echo "[INFO] Applying Terraform with heartbeat logging"
                    {
                      while true; do
                        echo "[Jenkins Watchdog] Terraform still running... $(date)"
                        sleep 30
                      done
                    } &
                    WATCHDOG_PID=$!

                    terraform apply -auto-approve | tee terraform.log
                    RESULT=$?

                    echo "[INFO] Stopping Jenkins Watchdog"
                    kill $WATCHDOG_PID
                    wait $WATCHDOG_PID 2>/dev/null

                    exit $RESULT
                '''
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
                sh '''
                    docker run -d --name testcontainer -p 8080:8080 myapp
                    for i in {1..10}; do
                      echo "[INFO] Waiting for app to respond... $((i*2))s"
                      sleep 2
                      curl --silent http://localhost:8080 && break
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
                    terraform destroy -auto-approve | tee terraform-destroy.log
                '''
            }
        }
    }
}
