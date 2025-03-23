pipeline {
    agent any
    triggers { pollSCM('H/5 * * * *') }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-ssh', 
                    url: 'git@github.com:haveheartt/mathoclock.git'
            }
        }
        stage('Build Backend') {
            steps {
                dir('api') {  // Change to the api directory
                    sh 'cargo build --release'
                }
            }
        }
        stage('Test Backend') {
            steps {
                dir('api') {  // Change to the api directory
                    sh 'cargo test'
                }
            }
        }
        stage('Commit Artifacts') {
            steps {
                script {
                    dir('api') {  // Change to the api directory for Cargo.lock
                        sh 'git config user.name "Jenkins CI"'
                        sh 'git config user.email "jenkins@mathoclock"'
                        sh 'git add Cargo.lock || true'
                        sh 'git diff --staged --quiet || git commit -m "CI: Update Cargo.lock"'
                        withCredentials([sshUserPrivateKey(credentialsId: 'github-ssh', keyFileVariable: 'SSH_KEY')]) {
                            sh '''
                                eval "$(ssh-agent -s)"
                                ssh-add $SSH_KEY
                                git push origin main
                            '''
                        }
                    }
                }
            }
        }
    }
    post {
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}