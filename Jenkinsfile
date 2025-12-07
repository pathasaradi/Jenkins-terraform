pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION    = "ap-south-1"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')   // IAM user access key
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')   // IAM user secret key
        TF_WORKDIR            = "jenkins_terraform/envs/dev"            // Change for stage/prod
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-org/aws-infra.git'
            }
        }

        stage('Terraform Fmt & Validate') {
            steps {
                sh "terraform -version"
                dir("${env.TF_WORKDIR}") {
                    sh 'terraform fmt -check'
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
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

    post {
        always {
            archiveArtifacts artifacts: '**/tfplan', allowEmptyArchive: true
        }
    }
}
