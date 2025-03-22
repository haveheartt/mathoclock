pipeline {
    agent any
    triggers { pollSCM('H/5 * * * *') } // Polling every 5 minutes
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-ssh', 
                    url: 'git@github.com:haveheartt/mathoclock.git'
            }
        }
        stage('Load Environment') {
            steps {
                script {
                    if (fileExists('.env')) {
                        echo "Loading .env"
                    } else {
                        echo "No .env file found. Using defaults."
                    }
                }
            }
        }
        stage('Build Backend') {
            steps {
                sh 'cargo build --release'
            }
        }
        stage('Test Backend') {
            steps {
                sh 'cargo test'
            }
        }
        stage('Commit Artifacts') {
            steps {
                script {
                    sh 'git config user.name "Jenkins CI"'
                    sh 'git config user.email "jenkins@mathoclock"'
                    sh 'git add backend/Cargo.lock || true'
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
    post {
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
