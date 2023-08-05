pipeline {
    agent any

    parameters {
        choice(choices: ['dev', 'prod'], description: 'Select the workspace', name: 'WORKSPACE')
        choice(choices: ['dev.tfvars', 'nonprod.tfvars'], description: 'Select the .tfvars file', name: 'TFVARS_FILE')
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
            }
            steps {
                script {
                    sh "terraform apply -var-file=${params.TFVARS_FILE} -auto-approve"
                }
            }
        }

        stage('Destroy') {
            when {
                expression { params.WORKSPACE == 'dev' || params.WORKSPACE == 'prod' }
            }
            steps {
                script {
                    sh "terraform destroy -var-file=${params.TFVARS_FILE}"
                }
            }
        }
    }
}
