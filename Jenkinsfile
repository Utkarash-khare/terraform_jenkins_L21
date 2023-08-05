pipeline {
    agent any

    parameters {
        choice(choices: ['dev', 'prod'], description: 'Select the workspace', name: 'WORKSPACE')
        choice(choices: ['dev.tfvars', 'nonprod.tfvars'], description: 'Select the .tfvars file', name: 'TFVARS_FILE')
        choice(choices: ['Plan', 'Apply', 'Destroy'], description: 'Select the action to perform', name: 'ACTION')
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

        stage('Plan') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
                expression { params.ACTION == 'Plan' }
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
                expression { params.ACTION == 'Apply' }
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
                expression { params.ACTION == 'Destroy' }
            }
            steps {
                script {
                    sh "terraform destroy -var-file=${params.TFVARS_FILE} -auto-approve"
                }
            }
        }
    }
}
