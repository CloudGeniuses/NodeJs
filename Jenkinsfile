pipeline {
    agent any

    environment {
        // Define environment variables
        DOCKER_IMAGE = "cloudgenius-app" // Name of the Docker image
        DOCKER_REGISTRY = "cloudgeniuslab" // Replace with your DockerHub username or registry
        DOCKER_TAG = "latest" // Tag for the Docker image
        DOCKER_CREDENTIALS = "docker-credentials-id" // Jenkins credentials ID for DockerHub
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/CloudGeniuses/NodeJs.git', branch: 'main'
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
