pipeline {
    agent any

    parameters {
        choice(
            choices: ['init', 'plan', 'apply', 'destroy'],
            description: 'Select the Terraform action to perform.',
            name: 'TERRAFORM_ACTION'
        )

        choice(
            choices: ['dev', 'prod'],
            description: 'Select the workspace.',
            name: 'WORKSPACE'
        )
      
        string(
            defaultValue: '',
            description: 'Enter the name of the .tfvars file (without extension) to use. Leave empty for default.',
            name: 'TFVARS_FILE'
        )
    }

    stages {
        
        stage('Initialize') {
            when {
                expression { params.TERRAFORM_ACTION == 'init' }
            }
            steps {
                script {
                    sh "terraform init"
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
                expression { params.TERRAFORM_ACTION != 'init' }
            }
            steps {
                script {
                    def tfAction = params.TERRAFORM_ACTION
                    def tfVarsFile = params.TFVARS_FILE != '' ? "-var-file=./${params.TFVARS_FILE}.tfvars" : ''
                    
                    // Execute the terraform action based on the selected option
                    sh "terraform ${tfAction} -input=false ${tfVarsFile}"
                }
            }
        }

        stage('Cleanup') {
            when {
                expression { params.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                script {
                    sh 'terraform state list | xargs -n 1 terraform state rm -force'
                }
            }
        }
    }
}
