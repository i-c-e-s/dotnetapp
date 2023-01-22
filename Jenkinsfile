pipeline {
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

        stage('Restore packages') {
            steps {
                bat "dotnet restore ${workspace}\\<path-to-solution>\\<solution-project-name>.sln"
            }
        }

        stage('Clean') { 
            steps { 
                bat "msbuild.exe ${workspace}\\<path-to-solution\\<solution-project-name>.sln" /nologo /nr:false /p:platform=\ "x64\" /p:configuration=\"release\" /t:clean" 
            } 
        }
    }
}