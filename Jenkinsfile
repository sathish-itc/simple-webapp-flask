pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/sathish-itc/simple-webapp-flask', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flask-img .'
            }
        }

        stage('Push to Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'sathish33', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker tag flask-img ${DOCKER_USER}/sathish-itc:v3
                        docker push ${DOCKER_USER}/sathish-itc:v3
                    '''
                }
            }
        }

        stage('Azure Login & AKS Setup') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aks-login',
                    usernameVariable: 'AZURE_CLIENT_ID',
                    passwordVariable: 'AZURE_CLIENT_SECRET'
                )]) {
                    sh """
                        az login --service-principal -u "$AZURE_CLIENT_ID" -p "$AZURE_CLIENT_SECRET" --tenant 2b32b1fa-7899-482e-a6de-be99c0ff5516
                        az aks get-credentials --resource-group rg-dev-flux --name aks-dev-flux-cluster --overwrite-existing
                        kubectl get pods -n default
                    """
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                sh "kubectl apply -f deployment.yaml -n devops"
            }
        }
    }
}

