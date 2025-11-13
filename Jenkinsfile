pipeline {
  agent any

  environment {
    TF_DIR = "${env.WORKSPACE}/environments/dev"
    PATH = "$HOME/terraform:$PATH"
  }

  stages {

    stage('Check PR target branch') {
      when {
        expression {
          return (env.CHANGE_TARGET == 'develop') || (env.BRANCH_NAME == 'develop')
        }
      }
      steps {
        echo "PR to develop detected, pipeline continues..."
      }
    }

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
            git clone -b develop \
            https://github.com/GeraldOpitz/Flask-App-User-Manager.git .
          '''
        }
      }
    }

    stage('Prepare Inventory and Run Ansible') {
      steps {
        script {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            def appIp = sh(
              script: "terraform -chdir=${TF_DIR} output -raw flask_app_public_ip",
              returnStdout: true
            ).trim()
            def dbIp = sh(
              script: "terraform -chdir=${TF_DIR} output -raw flask_db_public_ip",
              returnStdout: true
            ).trim()
            echo "Terraform outputs -> App IP: ${appIp}, DB IP: ${dbIp}"

            if (!appIp || !dbIp) {
              error "One or more Terraform outputs are empty (App: ${appIp}, DB: ${dbIp})."
            }

            sh "sed -i \"s|REPLACE_APP_IP|${appIp}|\" ${env.WORKSPACE}/ansible/ansible/inventories/dev/inventory.ini"
            sh "sed -i \"s|REPLACE_DB_IP|${dbIp}|\" ${env.WORKSPACE}/ansible/ansible/inventories/dev/inventory.ini"
          }

          withCredentials([string(credentialsId: 'ansible_vault_pass', variable: 'VAULT_PASS')]) {
            sshagent(['ec2-app-key', 'ec2-db-key']) {
              sh '''
                echo "$VAULT_PASS" > ${WORKSPACE}/ansible/.vault_pass.txt
                chmod 600 ${WORKSPACE}/ansible/.vault_pass.txt
                ssh-add -l
                ansible-playbook \
                  -i ${WORKSPACE}/ansible/ansible/inventories/dev/inventory.ini \
                  ${WORKSPACE}/ansible/ansible/playbooks.yml \
                  --vault-password-file ${WORKSPACE}/ansible/.vault_pass.txt \
                  -u ubuntu
                rm -f ${WORKSPACE}/ansible/.vault_pass.txt
              '''
            }
          }
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
