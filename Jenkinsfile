pipeline {
    agent any

    triggers {
        githubPush() // trigger on gitHub push
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: env.GIT_CREDENTIALS_ID ?: 'github-ssh', // fallback if .env not loaded yet
                    url: 'git@github.com:haveheartt/mathoclock.git'
            }
        }

        stage('Load Environment') {
            steps {
                script {
                    // load .env file if it exists
                    if (fileExists('.env')) {
                        def envContent = readFile('.env').trim()
                        envContent.split('\n').each { line ->
                            if (!line.startsWith('#') && line.contains('=')) {
                                def (key, value) = line.split('=', 2)
                                env."${key.trim()}" = value.trim()
                            }
                        }
                    } else {
                        echo "No .env file found. Using defaults."
                    }
                    // define NIX_SHELL with loaded env
                    env.NIX_SHELL = "nix develop --command bash -c"
                }
            }
        }

        stage('Setup Environment') {
            steps {
                sh 'nix flake update' // update flake.lock
                sh 'direnv allow'
                sh 'eval "$(direnv export bash)"'
            }
        }

        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh '$NIX_SHELL "cargo build --release"'
                }
            }
        }

        stage('Test Backend') {
            steps {
                dir('backend') {
                    sh '$NIX_SHELL "cargo test"'
                }
            }
        }

        stage('Commit Artifacts') {
            steps {
                script {
                    sh 'git config user.name "guilherme"'
                    sh 'git config user.email "guilhermev2huehue@gmail.com"'

                    sh 'git add api/Cargo.lock || true'
                    sh 'git diff --staged --quiet || git commit -m "CI: Update Cargo.lock from build"'

                    withCredentials([sshUserPrivateKey(credentialsId: env.GIT_CREDENTIALS_ID ?: 'github-ssh', keyFileVariable: 'SSH_KEY')]) {
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
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
