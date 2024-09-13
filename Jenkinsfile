pipeline {
    agent {
        docker { image 'docker:latest' }
    }
    environment {
        DOCKER_IMAGE = "cloudgenius-app"
        DOCKER_REGISTRY = "cloudgeniuslab"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS = "docker-credentials-id"
        AWS_CREDENTIALS = "aws-credentials-id"
        EKS_CLUSTER_NAME = "my-eks-cluster"
        AWS_REGION = "us-east-2"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/CloudGeniuses/NodeJs.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: DOCKER_CREDENTIALS, url: 'https://index.docker.io/v1/') {
                        docker.image("${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }
}
