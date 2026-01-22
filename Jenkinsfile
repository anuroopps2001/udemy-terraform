pipeline{
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages{
        stage("checkout"){
            steps{
                echo "========executing checkout========"
                checkout scm
            }
        }


            stage("Terraform init") {
                steps {
                    echo "========executing Terraform init========"
                    withCredentials([[ 
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-terraform'
                    ]]){
                        sh 'env | grep AWS'
                        sh 'terraform -chdir=proj02-iam-users init'
                }
            }
        }  
            
            stage("Terraform validate") {
                steps {
                    echo "=========executing terraform validate======="
                    withCredentials([[ 
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-terraform'
                    ]]){
                    sh 'terraform -chdir=proj02-iam-users validate'
                }
            }
            }

            stage ("Terraform plan") {
                steps {
                    echo "=========executing terraform plan======"
                    withCredentials([[ 
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-terraform'
                    ]]){
                    sh 'terraform -chdir=proj02-iam-users plan'
                }
            }

            stage ("Terraform Apply (manual Approval)") {
                when {
                    branch 'main'
                }
                steps {
                    echo "========executing terraform manual apply======"
                    withCredentials([[ 
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-terraform'
                    ]]){
                    input message: "Apply Terraform changes?"
                    sh 'terraform -chdir=proj02-iam-users apply -auto-approve'
                }
            }
               
        }
    }