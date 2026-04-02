pipeline {
    agent { label 'maven' }

    stages {

        stage('Build') {
            steps {
                echo "Build started"
                sh 'mvn clean package'
                echo "Build completed"
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'project2-sonarqube-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}