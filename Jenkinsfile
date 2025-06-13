pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token', branch: 'main', url: 'https://github.com/krishapatel180305/simple-java-maven-2025.git'
            }
        }
    }
}
