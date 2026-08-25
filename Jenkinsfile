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
                    sh "docker build -t ${DOCKER_IMAGE}:${imageTag} ."
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${imageTag}"
                    }
                }
            }
        }

        stage('Update GitOps Repo') {
            steps {
                script {
                    def imageTag = "${BUILD_NUMBER}"
                    
                    withCredentials([string(credentialsId: 'github-pat', variable: 'GITHUB_TOKEN')]) {
                        sh "git clone https://${GITHUB_TOKEN}@${GITOPS_REPO} gitops-dir"
                        
                        dir('gitops-dir') {
                            // Linux sed command to replace image tag in deployment.yaml
                            sh "sed -i 's|image: ${DOCKER_IMAGE}:.*|image: ${DOCKER_IMAGE}:${imageTag}|g' deployment.yaml"
                            
                            sh "git config user.email 'jenkins@ci.com'"
                            sh "git config user.name 'Jenkins CI'"
                            sh "git add deployment.yaml"
                            sh "git commit -m \"Update image tag to ${imageTag} [skip ci]\""
                            sh "git push origin main"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            sh "rm -rf gitops-dir"
        }
    }
}