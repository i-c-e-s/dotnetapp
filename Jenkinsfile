pipeline {

    //variáveis de ambiente
    environment {
        dockerimagename = "ices/dotnetapp"
        dockerImage = ""
    }

    //agente que vai executar o CI
    agent any

    //ignorar o default checkout
    options {
        skipDefaultCheckout()
    }

    stages {
        //limpeza do workspace
        stage ('Clean workspace') {
            steps {
                cleanWs()
            }
        }
        //checkout do projeto
        stage ('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/i-c-e-s/dotnetapp'
            }
        }
        //testes do sonar
        /*stage ('Sonarqube validation') {
            steps {
                script {
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=dotnetapp -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
                }
            }

        }
        
        stage ("Quality gate") {
            steps {
                waitForQualityGate abortPipeline: True
                sh 'echo "Pipeline aborted due to quality gate failure!"'
            }
        }*/
        //build da aplicação
        stage ('Build image') {
            steps {
                script {
                    dockerImage = docker.build dockerimagename
                }
            }
        }
        //testes na imagem
        stage ('Test Image application') {
            steps {
                sh 'docker-compose up -d'
                sh 'sleep 10'
                sh './teste-app.sh'
                sh 'docker-compose down'
            }
        }
        //publicacao da imagem no nexus
        stage ('Pushing Docker Image') {
            steps {
                script {
                    /*withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag ices/dotnetapp:latest ${NEXUS_URL}/ices/dotnetapp'
                        sh 'docker push ${NEXUS_URL}/ices/dotnetapp'*/
                    withCredentials([
                        string(credentialsId: "AWS_ACCESS_KEY_ID", variable: "AWS_ACCESS_KEY_ID"),
                        string(credentialsId: "AWS_SECRET_ACCESS_KEY", variable: "AWS_SECRET_ACCESS_KEY"),
                        string(credentialsId: "AWS_DEFAULT_REGION", variable: "AWS_DEFAULT_REGION"),
                        string(credentialsId: "AWS_ECR_URL", variable: "AWS_ECR_URL"),
                        string(credentialsId: "ECR_REPOSITORY", variable: "ECR_REPOSITORY"),]){
                        sh "aws configure set aws_access_key_id ${env.AWS_ACCESS_KEY_ID}"
                        sh "aws configure set aws_secret_access_key ${env.AWS_SECRET_ACCESS_KEY}"
                        sh "aws configure set region ${env.AWS_DEFAULT_REGION}"
                        sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${env.AWS_ECR_URL}"
                        sh "docker tag ices/dotnetapp ${env.AWS_ECR_URL}/${env.ECR_REPOSITORY}:latest"
                        sh "docker push ${env.AWS_ECR_URL}/${env.ECR_REPOSITORY}:latest"
                    }
                }
            }
        }
    }
}