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
                    withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform']]){
                        sh 'terraform init'
                }
            }
        }  
            
            stage("Terraform validate") {
                steps {
                    echo "=========executing terraform validate======="
                    sh 'terraform validate'
                }
            }

            stage ("Terraform plan") {
                steps {
                    echo "=========executing terraform plan======"
                    sh 'terraform plan'
                }
            }

            stage ("Terraform Apply (manual Approval)") {
                when {
                    branch 'main'
                }
                steps {
                    echo "========executing terraform manual apply======"
                    input message: "Apply Terraform changes?"
                    sh 'terraform apply -auto-approve'
                }
            }
               
        }
    }