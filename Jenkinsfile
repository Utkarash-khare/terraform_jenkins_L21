pipeline {
    agent any

    parameters {
        choice(choices: ['dev', 'prod'], description: 'Select the workspace', name: 'WORKSPACE')
        choice(choices: ['dev.tfvars', 'nonprod.tfvars'], description: 'Select the .tfvars file', name: 'TFVARS_FILE')
        booleanParam(name: 'RUN_PLAN', defaultValue: true)
        booleanParam(name: 'RUN_APPLY', defaultValue: false)
        booleanParam(name: 'RUN_DESTROY', defaultValue: false)
        booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Automatically approve the Terraform changes (apply and destroy)')
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Prepare Workspace') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
            }
            steps {
                script {
                    def workspace = params.WORKSPACE
                    sh "terraform workspace new ${workspace} || true"
                    sh "terraform workspace select ${workspace}"
                }
            }
        }

        stage('Plan') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
                expression { params.RUN_PLAN == true }
            }
            steps {
                script {
                    sh "terraform plan -var-file=${params.TFVARS_FILE}"
                }
            }
        }

        stage('Apply') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
                expression { params.RUN_APPLY == true }
            }
            steps {
                script {
                    def autoApproveFlag = params.AUTO_APPROVE ? "-auto-approve" : ""
                    sh "terraform apply -var-file=${params.TFVARS_FILE} ${autoApproveFlag}"
                }
            }
        }

        stage('Destroy') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
                expression { params.RUN_DESTROY == true }
            }
            steps {
                script {
                    sh "terraform destroy -var-file=${params.TFVARS_FILE} ${autoApproveFlag}"
                }
            }
        }
    }
}
