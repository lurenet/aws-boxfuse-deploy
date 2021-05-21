#!/usr/bin/env groovy

pipeline {
    
    agent none
    
    environment {
        
        AWS_CRED_PATH   = "/root/.aws"
        EXPORT_PATH     = "/tmp/export"
        
        TERRAFORM_IMAGE = "nickmas/terraform-agent:latest"
        ANSIBLE_IMAGE   = "nickmas/ansible-agent:latest"
        
        DHUB_USERNAME   = "username"
        DHUB_PASSWORD   = "password"
        DHUB_EMAIL      = "user@gmail.com"
    }
    
    parameters {
        choice(
            choices: ['create' , 'destroy'],
            description: 'Select one of the list what we will do',
            name: 'ACTION')
    }
    
    
    stages {
        
        stage ('prepeare temporary environment') {
            
            agent any
            
            steps {
                sh "if [ ! -d ${env.EXPORT_PATH} ]; then mkdir -p ${env.EXPORT_PATH}; fi"
            }
        } 
        
        stage('create environment in aws:') {
            
            agent {
                docker {
                    image env.TERRAFORM_IMAGE
                    args '--privileged -u root:sudo -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.m2:/root/.m2 -v "'+env.AWS_CRED_PATH+'":/root/.aws  -v $HOME/.m2:/root/.m2 -v "'+env.EXPORT_PATH+'":/root/export'
                }
            }
            
            stages {
                
                stage ('pull *.tf') {
                    steps {
                        git branch: 'main', url: 'https://github.com/lurenet/terraform-aws-agent.git'
                    }
                }
    
                stage ('create instances') {
                    
                    when { 
                        expression { params.ACTION == 'create' }
                    }
                    
                    steps {
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                            cp terraform.tfstate /root/export
                        '''
                    }
                }
                
                stage ('destroy instances') {
                    
                    when { 
                        expression { params.ACTION == 'destroy' }
                    }
                    
                    steps {
                        sh '''
                            terraform init
                            cp /root/export/terraform.tfstate .
                            terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }
        
        stage('work with instances:') {
            
            agent {
                docker {
                    image env.ANSIBLE_IMAGE
                    args '--privileged -u root:sudo -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.m2:/root/.m2 -v $HOME/.m2:/root/.m2 -v "'+env.EXPORT_PATH+'":/root/export'
                }
            }
            
            stages {
                
                stage ('set dhub cred') {
                    
                    when { 
                        expression { params.ACTION == 'create' }
                    }
                    
                    steps {
                        sh '''
                            if [ ! -d config ]; then mkdir -p config; fi
                            echo \"---\ndhub_username: ${DHUB_USERNAME}\ndhub_password: ${DHUB_PASSWORD}\ndhub_email: ${DHUB_EMAIL}\n\" > config/dockerhub.yml
                        '''
                    }
                }
                
                stage ('pull playbook') {
                    
                    when { 
                        expression { params.ACTION == 'create' }
                    }
                    
                    steps {
                        git branch: 'main', url: 'https://github.com/lurenet/ansible-aws-agent.git'
                    }
                }
                
                stage ('install apps, build and run') {
                    
                    when { 
                        expression { params.ACTION == 'create' }
                    }
                    
                    steps {
                        sh '''
                            ansible-playbook -i /root/export/hosts aws.yml
                        '''
                    }
                }
                
                stage ('show url') {
                    
                    when { 
                        expression { params.ACTION == 'create' }
                    }
                    
                    steps {
                        script {
                            load "${EXPORT_PATH}/env.groovy"
                            echo "Visit Boxfuse: http://${env.BOXFUSE_IP}/${env.BOXFUSE_NAME}"
                        }
                    }
                }
            }
        }
    }
}