node{
   stage('GitHub Checkout'){
       git credentialsId: 'GitHubCredentials', url: 'https://github.com/itsmydevops/spring-mvc-hello-world.git'
   }
   
   stage('Maven Package'){
     def mvnHome = tool name: 'Maven', type: 'maven'
     def mvnCMD = "${mvnHome}/bin/mvn"
     sh "${mvnCMD} clean package"
   }
   
  stage('Build Docker Image'){
     sh 'docker build -t bathurudocker/springapp:3.0.0 .'
   }
   
  stage('Push Docker Image'){
     withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerpwd')]) {
        sh "docker login -u bathurudocker -p ${dockerpwd}"
     }
     sh 'docker push bathurudocker/springapp:3.0.0'
   }
  
     stage('Run Container on Dev Server'){
     sh 'docker run -p 8090:8080 -d --name springapp bathurudocker/springapp:3.0.0'
   }
   
}
