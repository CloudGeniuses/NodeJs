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

        stage('Clean Up Old Installations') {
            steps {
                script {
                    sh '''
                    if [ -d /var/lib/jenkins/aws-cli ]; then
                        echo "Removing old AWS CLI installation..."
                        rm -rf /var/lib/jenkins/aws-cli
                    fi
                    if [ -f /var/lib/jenkins/bin/eksctl ]; then
                        echo "Removing old eksctl installation..."
                        rm -f /var/lib/jenkins/bin/eksctl
                    fi
                    '''
                }
            }
        }

        stage('Install Tools') {
            steps {
                script {
                    sh '''
                    # Update package list and install necessary tools
                    sudo apt-get update
                    sudo apt-get install -y unzip curl

                    # Create directory for eksctl if it does not exist
                    sudo mkdir -p /var/lib/jenkins/bin

                    # Install eksctl if not present
                    if ! command -v eksctl &> /dev/null; then
                        echo "Installing eksctl..."
                        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
                        if [ -f /tmp/eksctl ]; then
                            sudo mv /tmp/eksctl /var/lib/jenkins/bin/eksctl
                        else
                            echo "Failed to download eksctl."
                            exit 1
                        fi
                    else
                        echo "eksctl already installed."
                    fi

                    # Verify installations
                    echo "eksctl version:"
                    eksctl version || true
                    '''
                }
            }
        }

        // Add more stages as needed (e.g., Build, Test, Deploy)
    }
}
