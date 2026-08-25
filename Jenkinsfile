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
                withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                        git config user.email "jenkins@ci.com"
                        git config user.name "Jenkins CI"
                        
                        # Replace any image string on the image line with the new build number
                        sed -i -E "s|(image: ).*|\\1${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_NUMBER}|g" k8s/deployment.yaml
                        
                        git add k8s/deployment.yaml
                        git commit -m "Jenkins CI: Update image tag to ${BUILD_NUMBER} [skip ci]" || echo "No changes to commit"
                        
                        git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/Margesh01/MySampleApi.git
                        git push origin main
                    '''
                }
            }
        }
    }
}