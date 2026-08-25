pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'margesh01/mysampleapi'
        GITOPS_REPO = 'github.com/Margesh01/MySampleApi-gitops.git'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Margesh01/MySampleApi.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def imageTag = "${BUILD_NUMBER}"
                    bat "docker build -t ${DOCKER_IMAGE}:${imageTag} ."
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        bat "docker push ${DOCKER_IMAGE}:${imageTag}"
                    }
                }
            }
        }

        stage('Update GitOps Repo') {
            steps {
                script {
                    def imageTag = "${BUILD_NUMBER}"
                    
                    withCredentials([string(credentialsId: 'github-pat', variable: 'GITHUB_TOKEN')]) {
                        bat "git clone https://%GITHUB_TOKEN%@${GITOPS_REPO} gitops-dir"
                        
                        dir('gitops-dir') {
                            bat "powershell -Command \"(Get-Content deployment.yaml) -replace 'image: ${DOCKER_IMAGE}:.*', 'image: ${DOCKER_IMAGE}:${imageTag}' | Set-Content deployment.yaml\""
                            
                            bat "git config user.email 'jenkins@ci.com'"
                            bat "git config user.name 'Jenkins CI'"
                            bat "git add deployment.yaml"
                            bat "git commit -m \"Update image tag to ${imageTag} [skip ci]\""
                            bat "git push origin main"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            bat "if exist gitops-dir rmdir /s /q gitops-dir"
        }
    }
}