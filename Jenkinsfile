pipeline {
    agent any

    environment {
        // Define environment variables here (optional)
        DOCKER_IMAGE = "cloudgenius-app" // Name of the Docker image
        DOCKER_REGISTRY = "cloudgeniuslab" // Replace with your DockerHub username or registry
        DOCKER_TAG = "latest" // Tag for the Docker image
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/CloudGeniuses/NodeJs.git', branch: 'main'
            }
        }

        // Add more stages as needed (e.g., Build, Test, Deploy)
    }
}
