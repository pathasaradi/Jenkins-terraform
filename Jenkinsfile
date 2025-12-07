pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
        TF_WORKDIR         = "jenkins-terraform/envs/dev"
        PATH               = "${env.WORKSPACE}/bin:/usr/bin:/bin"
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

        stage('Install Terraform') {
            steps {
                sh '''
                yum install -y unzip

                curl -o terraform.zip https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
                unzip -o terraform.zip

                mkdir -p $WORKSPACE/bin
                mv terraform $WORKSPACE/bin/

                terraform -version
                '''
            }
        }

        stage('Terraform Fmt & Validate') {
            steps {
                dir("${env.TF_WORKDIR}") {
                    sh '''
                    terraform fmt -check
                    terraform init -input=false
                    terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TF_WORKDIR}") {
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
