pipeline {
    agent { label 'maven' }

    stages {

        stage('Build JAR') {
            steps {
                echo "Building application..."
                sh 'mvn clean package -DskipTests'
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

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t tweet-trend-app .'
            }
        }

        stage('Deploy Container') {
            steps {
                echo "Deploying Docker container..."

                sh '''
                docker rm -f tweet-trend-container || true

                docker run -d \
                  --name tweet-trend-container \
                  -p 8080:8080 \
                  tweet-trend-app
                '''
            }
        }
    }
}