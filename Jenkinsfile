pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
        TF_WORKDIR         = "envs/dev"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pathasaradi/Jenkins-terraform.git'
            }
        }

        stage('Load AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access-key'
                ]]) {
                    sh 'echo "AWS credentials loaded"'
                }
            }
        }

        stage('Terraform Fmt & Validate') {
            steps {
                sh '''
                    cd envs/dev
                    ls
                    pwd
                    terraform init -reconfigure
                    '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TF_WORKDIR}") {
                    sh 'terraform plan'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Apply changes to AWS infrastructure?'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TF_WORKDIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Outputs') {
            steps {
                dir("${env.TF_WORKDIR}") {
                    sh 'terraform output'
                }
            }
        }
    }
}
