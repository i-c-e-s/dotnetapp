pipeline {

    environment {
        dockerimagename = "ices/dotnetapp:v1"
        dockerImage = ""
    }

    agent any

    options {
        skipDefaultCheckout()
    }

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

        /*stage ('Sonarqube validation') {
            steps {
                script {
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=dotnetapp -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
                }
            }

        }*/

        stage ('Build image') {
            steps {
                script {
                    dockerImage = docker.build dockerimagename
                }
            }
        }

        stage ('Test Image') {
            steps {
                sh 'docker-compose up -d'
                sh 'sleep 10'
                sh './teste-app.sh'
                sh 'docker-compose down'
            }
        }

        stage ('Pushing Image') {
            environment {
                registryCredential = 'dockerhublogin'
            }

            steps {
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
                        dockerImage.push("v1")
                    }
                }
            }
        }

        stage ('Deploying App to Kubernetes') {
            steps {
                sh 'echo $PWD'
                sh 'helm upgrade dotnetapp helm-chart/'
            }
        }
    }
}