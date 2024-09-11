pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        EKS_CLUSTER_NAME = 'my-eks-cluster'
        DOCKER_IMAGE = 'kamran111/valleyjs:latest'
        DOCKER_CREDENTIALS = 'docker-cred' // Docker Hub credentials in Jenkins
        AWS_CREDENTIALS = 'aws-credentials'
        AWS_CLI_VERSION = '2.17.46'
        EKSCTL_VERSION = '0.190.0'
        PATH = '/var/lib/jenkins/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/kamranali111/valley_js.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
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
                    if ! command -v aws &> /dev/null; then
                        echo "Installing AWS CLI..."
                        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                        unzip awscliv2.zip -d /var/lib/jenkins/aws-cli
                        /var/lib/jenkins/aws-cli/aws/install --install-dir /var/lib/jenkins/aws-cli --bin-dir /var/lib/jenkins/bin
                    else
                        echo "Updating AWS CLI..."
                        /var/lib/jenkins/aws-cli/aws/install --install-dir /var/lib/jenkins/aws-cli --bin-dir /var/lib/jenkins/bin --update
                    fi

                    # Install eksctl if not present
                    if ! command -v eksctl &> /dev/null; then
                        echo "Installing eksctl..."
                        curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
                        mv /tmp/eksctl /var/lib/jenkins/bin/eksctl
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

        // Further stages can be added as per the deployment requirements
    }
}
