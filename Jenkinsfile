pipeline {
    agent any

    environment {
        // Define environment variables here (optional)
        DOCKER_IMAGE = "cloudgenius-app" // Name of the Docker image
        DOCKER_REGISTRY = "cloudgeniuslab" // Replace with your DockerHub username or registry
        DOCKER_TAG = "latest" // Tag for the Docker image
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the source repository (Git, etc.)
                checkout scm
            }
        }

        // You can add more stages here (e.g., Build, Test, Deploy)
    }
}
