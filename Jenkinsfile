pipeline {
  agent any

  environment {
    TF_DIR = 'environments/dev'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir("${TF_DIR}") {
          script {
            def terraformHome = tool name: 'Terraform 1.6.4', type: 'terraform'

            withEnv(["PATH+TERRAFORM=${terraformHome}"]) {
              withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                sh '''
                  echo "=== Starting Terraform ==="
                  terraform version
                  terraform init -reconfigure -backend-config="backend.hcl"
                '''
              }
            }
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${TF_DIR}") {
          script {
            def terraformHome = tool name: 'Terraform 1.6.4', type: 'terraform'

            withEnv(["PATH+TERRAFORM=${terraformHome}"]) {
              withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                sh '''
                  echo "=== Planning changes ==="
                  terraform plan -out=tfplan
                '''
              }
            }
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir("${TF_DIR}") {
          script {
            def terraformHome = tool name: 'Terraform 1.6.4', type: 'terraform'

            withEnv(["PATH+TERRAFORM=${terraformHome}"]) {
              withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                sh '''
                  echo "=== Applying changes ==="
                  terraform apply -auto-approve tfplan
                '''
              }
            }
          }
        }
      }
    }
  }

  post {
    success {
      echo "Resources created."
    }
    failure {
      echo "Failed to create resources."
    }
  }
}
