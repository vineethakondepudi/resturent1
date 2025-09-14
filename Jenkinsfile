// Declarative Jenkins pipeline
}


stages {
stage('Checkout') {
steps {
checkout scm
}
}


stage('Install & Build') {
steps {
echo 'Installing node modules and building the React app'
// Use a node container on Jenkins agents that support Docker, or install Node on agent
sh 'npm ci'
sh 'npm run build'
}
}


stage('Build Docker Image') {
steps {
script {
sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
}
}
}


stage('Push to Docker Hub') {
steps {
withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
}
}
}


stage('Cleanup local images') {
steps {
sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
}
}
}


post {
success {
echo "Build and push succeeded: ${IMAGE_NAME}:${IMAGE_TAG}"
}
failure {
echo 'Pipeline failed.'
}
always {
cleanWs()
}
}
}
