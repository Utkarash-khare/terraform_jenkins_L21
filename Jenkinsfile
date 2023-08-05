pipeline {
    agent any

    parameters {
        choice(choices: ['dev', 'prod'], description: 'Select the workspace', name: 'WORKSPACE')
        choice(choices: ['dev.tfvars', 'nonprod.tfvars'], description: 'Select the .tfvars file', name: 'TFVARS_FILE')
        choice(choices: ['Plan', 'Apply', 'Destroy'], description: 'Select the action to perform', name: 'ACTION')
        booleanParam(name: 'AUTO_PLAN', defaultValue: false, name: 'PLAN')
        booleanParam(name: 'AUTO_APPLY', defaultValue: false, name: 'APPLY' )
        booleanParam(name: 'AUTO_DESTROY', defaultValue: false, name: 'DESTROY')
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
                expression { params.PLAN == 'Plan' }
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
                expression { params.APPLY == 'Apply' }
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
                expression { params.DESTROY == 'Destroy' }
            }
            steps {
                script {
                    sh "terraform destroy -var-file=${params.TFVARS_FILE} -auto-approve"
                }
            }
        }
    }
}
