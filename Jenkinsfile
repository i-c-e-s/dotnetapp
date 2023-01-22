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
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/i-c-e-s/skyactivationcore'
            }
        }

        stage('Build image') {
            steps{
                script {
                    dockerImage = docker.build dockerimagename
                }
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
                kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubernetes")
                }
            }
        }
    }
}