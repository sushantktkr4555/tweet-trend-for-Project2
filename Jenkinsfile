pipeline {
    agent { label 'maven' }

    environment {
        JFROG_CREDS = credentials('jfrog-cred')
        JFROG_CLI = tool 'jfrog-cli'
    }

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

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Upload to JFrog') {
            steps {
                 sh """
                ${JFROG_CLI}/jf rt upload "target/*.jar" "maven-repo-local/" --url=http://65.0.168.158:8082/artifactory --user=\$JFROG_CREDS_USR --apikey=\$JFROG_CREDS_PSW
                """
            }
        }
    }
}