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
        SCANNER_HOME = tool name: 'sonar-scanner', type: 'SonarQubeScanner'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/kamranali111/valley_js.git', branch: 'main'
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

        // Add more stages here as needed
    }
}
