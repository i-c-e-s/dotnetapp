pipeline {

    environment {
        dockerimagename = "ices/dotnetapp"
        dockerImage = ""
    }

    agent { label "cobaia-server-aws" }

    stages {
        stage ('Clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage ('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/i-c-e-s/dotnetapp'
            }
        }

        stage('Build image') {
            steps{
                script {
                    dockerImage = docker.build dockerimagename
                }
            }
        }

        stage ('test image') {
            steps {
                sh 'docker-compose up --build -d'
            }

            steps {
                sh 'sleep 10'
            }

            steps {
                sh './teste-app.sh'
            }

            steps {
                sh 'docker-compose down'
            }
        }

        stage('Pushing Image') {
            environment {
                registryCredential = 'dockerhublogin'
            }

            steps{
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploying App to Kubernetes') {
            steps {
                script {
                kubernetesDeploy(configs: "helm-chart/template/deployment.yml", kubeconfigId: "kubernetes")
                }
            }
        }
    }
}