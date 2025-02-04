pipeline {
    agent any
    
    environment {
        
        DOCKER_IMAGE_NAME = 'helloworld-java'  // Docker image name
        DOCKER_TAG = 'latest'  // Docker image tag
        AWS_REGION = 'us-east-1'  // AWS region
        AWS_ECR_REPO = '984954343645.dkr.ecr.us-east-1.amazonaws.com/helloworld-java'  // ECR repository URL
        EKS_CLUSTER = 'main-eks-cluster'
        EKS_AWS_REGION = 'us-west-2'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/saisudhavana/simple-java-maven-app.git'
            }
        }
        
        
        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean install'
                sh 'ls target/'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh """
                        docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .
                        docker images
                    """
                }
            }
        }
        
        
        stage('Login to AWS ECR') {
            steps {
                script {
                    // Authenticate Docker to AWS ECR using Jenkins credentials
                    withCredentials([aws(credentialsId: 'Jenkins-aws', region: AWS_REGION)]) {
                        sh """
                            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO}
                        """
                    }
                }
            }
        }

        
        
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Tag and push the Docker image to ECR
                    sh """
                        docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${AWS_ECR_REPO}:${BUILD_ID}
                        docker push ${AWS_ECR_REPO}:${BUILD_ID}
                    """
                }
            }
        }
        
        
        
        stage('Authenticate with EKS') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'Jenkins-aws', region: EKS_AWS_REGION)]) {
                        sh 'aws eks update-kubeconfig --region $EKS_AWS_REGION --name $EKS_CLUSTER'
                        echo "##########################################"
                        echo "Deploying Kubernetes Manifests ........."
                        echo "deploying application.........."
                        sh 'kubectl apply -f kubernetes-manifests/.'
                    }
                }
            }
        }
        
        
        
        
    }
}
