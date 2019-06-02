node{
   stage('GitHub Checkout'){
       git credentialsId: 'GitHubCredentials', 
                     url: 'https://github.com/itsmydevops/SpringHelloWorld.git'
   }
   
   stage('Maven Package'){
     def mvnHome = tool name: 'Maven', type: 'maven'
     def mvnCMD = "${mvnHome}/bin/mvn"
     sh "${mvnCMD} clean package"
   }

   stage('Copy to Nexux Repository'){
   nexusPublisher   nexusInstanceId: 'NexusRepoServer', 
                  nexusRepositoryId: 'DevopsNexusRepo', 
                           packages: [[$class: 'MavenPackage', 
                     mavenAssetList: [[classifier: '', 
                          extension: '', 
                           filePath: '/Users/srinivas/.jenkins/workspace/Deploy_Docker/target/springhelloworld-1.0.war']], 
                    mavenCoordinate: [artifactId: 'springhelloworld', 
                            groupId: 'com.itsmydevops', 
                          packaging: 'war', 
                            version: '1.0']]]
   
   } 
  stage('Build Docker Image'){
     sh 'docker build -t bathurudocker/springapp:5.0.0 .'
   }
   
  stage('Push Docker Image'){
     withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerpwd')]) {
        sh "docker login -u bathurudocker -p ${dockerpwd}"
     }
     sh 'docker push bathurudocker/springapp:5.0.0'
   }
  
   stage('Run Container on Dev Server'){
     sh 'docker run -p 8090:8080 -d --name springapp bathurudocker/springapp:5.0.0'
   }
   
    stage('Email Notification'){
      mail  bcc: '', 
           body: '''Hi Welcome to jenkins email alerts
                 Thanks
                 Srini''', 
             cc: '', 
           from: '', 
        replyTo: '', 
        subject: 'Jenkins Job', 
             to: 'srinivas.bathuru@gmail.com'
   }
}
