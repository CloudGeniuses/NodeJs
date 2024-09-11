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
                    # Update package list
                    sudo apt-get update

                    # Install unzip if not present
                    if ! command -v unzip &> /dev/null; then
                        echo "Installing unzip..."
                        sudo apt-get install -y unzip
                    fi

                    # Install AWS CLI if not present
                    if ! command -v aws &> /dev/null; then
                        echo "Installing AWS CLI..."
                        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                        unzip awscliv2.zip -d /var/lib/jenkins/aws-cli
                        sudo /var/lib/jenkins/aws-cli/aws/install --install-dir /var/lib/jenkins/aws-cli --bin-dir /var/lib/jenkins/bin
                    else
                        echo "Updating AWS CLI..."
                        sudo /var/lib/jenkins/aws-cli/aws/install --install-dir /var/lib/jenkins/aws-cli --bin-dir /var/lib/jenkins/bin --update
                    fi

                    # Install eksctl if not present
                    if ! command -v eksctl &> /dev/null; then
                        echo "Installing eksctl..."
                        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
                        sudo mv /tmp/eksctl /var/lib/jenkins/bin/eksctl
                    else
                        echo "eksctl already installed."
                    fi

                    # Verify installations
                    echo "AWS CLI version:"
                    aws --version || true
                    echo "eksctl version:"
                    eksctl version || true
                    '''
                }
            }
        }

        // Add more stages as needed (e.g., Build, Test, Deploy)
    }
}
