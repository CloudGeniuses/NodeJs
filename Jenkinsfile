pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        EKS_CLUSTER_NAME = 'my-eks-cg-cluster'
        DOCKER_IMAGE = 'cloudgeniuslab/cloudgenius-app'
        DOCKER_CREDENTIALS = 'dockerhub-cred' // Docker Hub credentials
        AWS_CREDENTIALS = 'Aws-cred' // AWS credentials
        AWS_CLI_VERSION = '2.17.46'
        EKSCTL_VERSION = '0.190.0'
        PATH = 'C:\\Program Files\\Amazon\\AWSCLIV2;C:\\Program Files\\Jenkins\\bin;C:\\Windows\\System32'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/CloudGeniuses/NodeJs.git', branch: 'main', credentialsId: 'git-cred'
            }
        }

        stage('Clean Up Old Installations') {
            steps {
                script {
                    bat '''
                    if exist "C:\\Program Files\\Jenkins\\aws-cli" (
                        echo Removing old AWS CLI installation...
                        rmdir /S /Q "C:\\Program Files\\Jenkins\\aws-cli"
                    )
                    if exist "C:\\Program Files\\Jenkins\\bin\\eksctl.exe" (
                        echo Removing old eksctl installation...
                        del /Q "C:\\Program Files\\Jenkins\\bin\\eksctl.exe"
                    )
                    '''
                }
            }
        }

        stage('Install Tools') {
            steps {
                script {
                    bat '''
                    if not exist "C:\\Program Files\\Amazon\\AWSCLIV2\\aws.exe" (
                        echo Installing AWS CLI...
                        curl -o awscliv2.zip "https://awscli.amazonaws.com/AWSCLIV2.msi"
                        msiexec.exe /i awscliv2.zip /quiet
                    ) else (
                        echo AWS CLI already installed.
                    )

                    if not exist "C:\\Program Files\\Jenkins\\bin\\eksctl.exe" (
                        echo Installing eksctl...
                        curl -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Windows_amd64.zip" -o eksctl.zip
                        tar -xf eksctl.zip -C "C:\\Program Files\\Jenkins\\bin"
                    ) else (
                        echo eksctl already installed.
                    )
                    '''
                }
            }
        }

        stage('Create EKS Cluster') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS]]) {
                        bat '''
                        set PATH=C:\\Program Files\\Jenkins\\bin;%PATH%
                        echo Checking if EKS cluster already exists...
                        eksctl get cluster --name %EKS_CLUSTER_NAME% --region %AWS_REGION%
                        if %ERRORLEVEL% neq 0 (
                            echo Creating EKS cluster...
                            eksctl create cluster --name %EKS_CLUSTER_NAME% --region %AWS_REGION% --nodegroup-name standard-workers --node-type t3.medium --nodes 2 --nodes-min 1 --nodes-max 3 --managed
                        ) else (
                            echo EKS cluster already exists.
                        )
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: DOCKER_CREDENTIALS, url: 'https://index.docker.io/v1/']) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Configure AWS CLI and kubectl') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS]]) {
                        bat '''
                        set PATH=C:\\Program Files\\Amazon\\AWSCLIV2;%PATH%
                        echo Running AWS CLI version:
                        aws --version
                        echo Updating kubeconfig...
                        aws eks update-kubeconfig --region %AWS_REGION% --name %EKS_CLUSTER_NAME%
                        '''
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    bat '''
                    set PATH=C:\\Program Files\\Jenkins\\bin;%PATH%
                    echo Running kubectl version:
                    kubectl version --client
                    echo Applying Kubernetes manifests...
                    kubectl apply -f k8s\\deployment.yaml
                    kubectl apply -f k8s\\service.yaml
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
