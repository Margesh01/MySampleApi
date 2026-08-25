pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mysampleapi'
        REGISTRY_USER = 'margesh01' // Change this
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Margesh01/MySampleApi.git'
            }
        }

        stage('Build & Test .NET') {
            steps {
                bat 'dotnet build --configuration Release'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }

        stage('Update Manifest & Push to Git') {
            steps {
                bat """
                    git config user.email "jenkins@ci.com"
                    git config user.name "Jenkins CI"
                    powershell -Command "(Get-Content k8s/deployment.yaml) -replace '${REGISTRY_USER}/${DOCKER_IMAGE}:.*', '${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_NUMBER}' | Set-Content k8s/deployment.yaml"
                    git add k8s/deployment.yaml
                    git commit -m "Jenkins CI: Update image to tag ${BUILD_NUMBER} [skip ci]"
                    git push origin main
                """
            }
        }
    }
}