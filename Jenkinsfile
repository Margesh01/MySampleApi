pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mysampleapi'
        REGISTRY_USER = 'margesh01'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Margesh01/MySampleApi.git'
            }
        }

        stage('Update Manifest & Push to GitOps') {
            steps {
                sh """
                    git config user.email "jenkins@ci.com"
                    git config user.name "Jenkins CI"
                    sed -i 's|${REGISTRY_USER}/${DOCKER_IMAGE}:.*|${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_NUMBER}|g' k8s/deployment.yaml
                    git add k8s/deployment.yaml
                    git commit -m "Jenkins CI: Update image tag to ${BUILD_NUMBER} [skip ci]" || echo "No changes to commit"
                    git push origin main
                """
            }
        }
    }
}