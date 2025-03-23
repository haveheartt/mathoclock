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
                dir('api') {
                    sh 'cargo build --release'
                }
            }
        }
        stage('Test Backend') {
            steps {
                dir('api') {
                    sh 'cargo test'
                }
            }
        }
        stage('Commit Artifacts') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    dir('api') {
                        sh 'git config user.name "Jenkins CI"'
                        sh 'git config user.email "jenkins@mathoclock"'
                        sh 'git add Cargo.lock || true'
                        // Only commit if there are changes
                        sh '''
                            if ! git diff --staged --quiet; then
                                git commit -m "CI: Update Cargo.lock after successful build and test"
                            else
                                echo "No changes to commit"
                            fi
                        '''
                        withCredentials([sshUserPrivateKey(credentialsId: 'github-ssh', keyFileVariable: 'SSH_KEY')]) {
                            sh '''
                                eval "$(ssh-agent -s)"
                                ssh-add $SSH_KEY
                                git push origin main || echo "Nothing to push"
                            '''
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
