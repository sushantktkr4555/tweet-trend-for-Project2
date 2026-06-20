pipeline {
    agent { label 'maven' }

    environment {
        PATH="/opt/apache-maven-3.9.11/bin:$PATH"
        DOCKER_IMAGE_NAME= 'ttrend'
        DOCKER_TAG= '2.1.3'
    }

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
                sh '''
                docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .
                '''
           }
         }


        stage('Verify AWS Auth') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-ecr-cred']]) {
                    sh 'aws sts get-caller-identity'
        }
    }
}


        stage('Push Image to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-ecr-cred']]) {
                    sh '''
                      ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
                      ECR_REPO=886993844830.dkr.ecr.ap-south-1.amazonaws.com/katkar/sush-app
 
                      echo "Logging in to ECR..."
                      aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${ECR_REPO}
 
                      echo "Tagging image..."
                      docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${ECR_REPO}:${DOCKER_TAG}
 
                      echo "Pushing image..."
                      docker push ${ECR_REPO}:${DOCKER_TAG}
                    '''
                }
            }
        }


        // 

        // stage('Deploy Container') {
        //     steps {
        //         echo "Deploying Docker container..."

        //         sh '''
        //         docker rm -f tweet-trend-container || true

        //         docker run -d \
        //           --name tweet-trend-container \
        //           -p 8080:8000 \
        //           tweet-trend-app
        //         '''
        //     }
        // }
    }
}