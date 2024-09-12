pipeline {
    agent any

    environment {
        // Define environment variables
        DOCKER_IMAGE = "cloudgenius-app" // Name of the Docker image
        DOCKER_REGISTRY = "cloudgeniuslab" // Replace with your DockerHub username or registry
        DOCKER_TAG = "latest" // Tag for the Docker image
        DOCKER_CREDENTIALS = "docker-credentials-id" // Jenkins credentials ID for DockerHub
        AWS_CREDENTIALS = "aws-credentials-id" // Jenkins credentials ID for AWS
        EKS_CLUSTER_NAME = "my-eks-cluster" // Name of the EKS cluster
        AWS_REGION = "us-east-1" // AWS region
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
                    # Install AWS CLI if not present
                    if ! command -v /var/lib/jenkins/bin/aws &> /dev/null; then
                        echo "Installing AWS CLI..."
                        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                        # Unzip without interactive prompts
                        unzip -o awscliv2.zip
                        ./aws/install -i /var/lib/jenkins/aws-cli -b /var/lib/jenkins/bin
                    else
                        echo "Updating AWS CLI..."
                        ./aws/install --update -i /var/lib/jenkins/aws-cli -b /var/lib/jenkins/bin
                    fi

                    # Install eksctl if not present
                    if ! command -v /var/lib/jenkins/bin/eksctl &> /dev/null; then
                        echo "Installing eksctl..."
                        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /var/lib/jenkins/bin
                    else
                        echo "eksctl already installed."
                    fi

                    # Verify installations
                    echo "AWS CLI version:"
                    /var/lib/jenkins/bin/aws --version || true
                    echo "eksctl version:"
                    /var/lib/jenkins/bin/eksctl version || true
                    '''
                }
            }
        }

        stage('Create EKS Cluster') {
            steps {
                script {
                    withCredentials([aws(credentialsId: AWS_CREDENTIALS)]) {
                        sh '''
                        echo "Checking if EKS cluster already exists..."
                        if eksctl get cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION; then
                            echo "EKS cluster already exists."
                        else
                            echo "Creating EKS cluster..."
                            eksctl create cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION --nodegroup-name standard-workers --node-type t3.medium --nodes 2 --nodes-min 1 --nodes-max 3 --managed
                        fi
                        '''
                    }
                }
            }
        }
    }
}
