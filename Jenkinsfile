pipeline {
  agent any

  environment {
    TF_DIR = 'environments/dev'
    PATH = "$HOME/terraform:$PATH"
  }

  stages {
    stage('Clean Workspace') {
      steps {
        deleteDir()
      }
    }

    stage('Checkout Terraform Project') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir("${TF_DIR}") {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh '''
              echo "Starting Terraform"
              terraform version
              terraform init -reconfigure -backend-config="backend.hcl"
            '''
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${TF_DIR}") {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh '''
              echo "Planning changes"
              terraform plan -out=tfplan
            '''
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir("${TF_DIR}") {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh '''
              echo "Applying changes"
              terraform apply -auto-approve tfplan
            '''
          }
        }
      }
    }

    stage('Terraform Output') {
      steps {
        dir("${TF_DIR}") {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh 'terraform output -json > tf-output.json'
          }
        }
      }
    }

    stage('Clone Ansible Project') {
      steps {
        dir("${env.WORKSPACE}/ansible") {
          sh 'rm -rf ./* ./.??* || true'
          
          sh '''
            git clone -b feature/FUM-52-Set-up-Ansible-project-structure \
            https://github.com/GeraldOpitz/Flask-App-User-Manager.git .
          '''
        }
      }
    }

    stage('Prepare Inventory and Run Ansible') {
      steps {
        script {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            def appIp = sh(script: "terraform -chdir=../environments/dev output -raw flask_app_public_ip", returnStdout: true).trim()
            echo "Terraform outputs -> App IP: ${appIp} (DB is private, using ProxyJump through App)"

            if (appIp) {
              sh "sed -i \"s|REPLACE_APP_IP|${appIp}|\" ${env.WORKSPACE}/ansible/inventories/dev/inventory.ini"
            } else {
              error "App IP is empty, cannot proceed."
            }
          }
          sh "ssh-add -D"
          sshagent(['ec2-app-key']) {
            sh "ssh-add -l" 
            sh "ansible-playbook -i inventories/dev/inventory.ini playbooks.yml"}
        }
      }
    }
  }
  
  post {
    success {
      echo "Resources created and configured with Ansible."
    }
    failure {
      echo "Failed to create or configure resources."
    }
  }
}
