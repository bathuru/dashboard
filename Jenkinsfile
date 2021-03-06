node{
   stage('GitHub Checkout'){
       git credentialsId: 'GitHubCredentials', 
                     url: 'https://github.com/itsmydevops/dashboard.git'
   }
   
   stage('Maven Build'){
     def mvnHome = tool name: 'Maven', type: 'maven'
     def mvnCMD = "${mvnHome}/bin/mvn"
     sh "${mvnCMD} clean package"
   }

   stage('SonarQube Analysis') {
        def mvnHome =  tool name: 'Maven', type: 'maven'
        withSonarQubeEnv('SonarQubeServer') { 
          sh "${mvnHome}/bin/mvn sonar:sonar"
        }
    }
   
   stage('Copy to Nexux Repo'){
   nexusPublisher   nexusInstanceId: 'NexusRepoServer', 
                  nexusRepositoryId: 'DevopsNexusRepo', 
                           packages: [[$class: 'MavenPackage', 
                     mavenAssetList: [[classifier: '', 
                          extension: '', 
                           filePath: '/Users/srinivas/.jenkins/workspace/dashboard/target/dashboard-1.0.war']], 
                    mavenCoordinate: [artifactId: 'dashboard', 
                            groupId: 'com.itsmydevops', 
                          packaging: 'war', 
                            version: '1.0']]]
   
   } 
    stage('Remove Previous Container'){
	try{
            sh 'docker rm -f dashboard'
	    sh 'docker rmi bathurudocker/dashboard'
	}catch(error){
		//  do nothing if there is an exception
	}
 }
  stage('Build Docker Image'){ 
     sh 'docker build -t bathurudocker/dashboard:latest .'
   }
   
  stage('Push Docker Image'){
     withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerpwd')]) {
        sh "docker login -u bathurudocker -p ${dockerpwd}"
     }
     sh 'docker push bathurudocker/dashboard:latest'
   }
  
   stage('Run Container'){
     sh 'docker run -p 8090:8080 -d --name dashboard bathurudocker/dashboard:latest'
   }
   
    stage('Email Notification'){
      emailext  bcc: '', 
           body: """Hi Team, 
	   
Your project Build and Deployed successfully.

Please find the details as below,
	   Job Name: ${env.JOB_NAME}
	   Job URL : ${env.JOB_URL}
	   
Thanks
DevOps Team""", 
             cc: '', 
           from: '', 
        replyTo: '', 
        subject: 'Jenkins Job Status', 
             to: 'srinivas.bathuru@gmail.com'
        attachLog: 'true'
   }
}
