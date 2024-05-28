pipeline {
    agent any

    stages {
        stage('gitclone') {
            steps {
                 git branch: 'master', url: 'https://github.com/Devikarani19/firstnewrepo'
                     
                 }
            }
           
        stage('init') {
            steps {
                sh 'terraform init'
                
                }
          }
    }
}
