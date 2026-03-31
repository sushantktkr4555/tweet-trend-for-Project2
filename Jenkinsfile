pipeline {
    agent { label 'maven' }

    stages {
        stage('Build') {
            steps {
                echo "build started"
                sh 'mvn clean deploy'
                echo "build completed"
            }
        }
    }
}