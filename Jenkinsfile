pipeline {
    agent any

    parameters {
        string(name: 'APP_VERSION', defaultValue: 'v3', description: 'Docker image version')
    }

    environment {
        IMAGE_NAME = "flask-img"
        DOCKER_REPO = "sathish-itc"
        NAMESPACE = "devops"
        RELEASE_NAME = "flask-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/sathish-itc/simple-webapp-flask', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$APP_VERSION ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'sathish33',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker tag $IMAGE_NAME:$APP_VERSION \$DOCKER_USER/$DOCKER_REPO:$APP_VERSION
                        docker push \$DOCKER_USER/$DOCKER_REPO:$APP_VERSION
                    """
                }
            }
        }

        stage('Deploy to Minikube using Helm') {
            steps {
                sh """
                    kubectl create namespace $NAMESPACE || true
                    helm upgrade --install $RELEASE_NAME ./helm \
                      --namespace $NAMESPACE \
                      --set image.repository=\$DOCKER_USER/$DOCKER_REPO \
                      --set image.tag=$APP_VERSION
                """
            }
        }
    }
}
