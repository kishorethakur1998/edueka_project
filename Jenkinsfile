pipeline {
    agent none 
        stages {
            stage('Puppet installation ') {
                agent {label 'slave'}
                steps {
                    sh '''
                        wget https://apt.puppetlabs.com/puppet7-release-focal.deb 
                        sudo dpkg -i puppet7-release-focal.deb 
                        sudo apt update 
                        sudo apt install puppet-agent -y 
                        sudo systemctl start puppet 
                        sudo systemctl status puppet 
                        
                       '''
                }
            }
            stage('Poll SCM') {
                agent any
                steps {
                    git branch: 'main', url: 'https://github.com/kishorethakur1998/edueka_project.git'
                }
            }
            stage('Execute ansible playbbok') {
                agent any
                steps {
                    ansiblePlaybook credentialsId: 'ansible_user', disableHostKeyChecking: true, installation: 'Ansible', inventory: 'dev.inv', playbook: 'docker-playbook.yaml'
                }
            }
            stage('Poll SCM in slave') {
                agent {label 'slave'}
                steps {
                    git branch: 'main', url: 'https://github.com/kishorethakur1998/edueka_project.git'
                }
            }
            stage('Docker build image') {
                agent {label 'slave'}
                steps {
                    sh 'docker build -t php-image .'
                }
            }
            stage('Deploy docker image') {
                agent {label 'slave'}
                steps {
                    sh 'docker run -d -p 8001:80 php-image:latest'
                }
                post {
                    failure {
                        script {
                            sh 'docker stop $(docker ps -aq)'
                            sh 'docker rm -f $(docker ps -aq)'
                        }
                    }
                }
            }
            
        }
}