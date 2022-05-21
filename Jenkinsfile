pipeline {
agent any
tools {
        maven "Maven 3.8.5"
        groovy "groovy-3.0.8"
        jdk "Java 8"
}
stages {
 stage("Code Checkout from github") {
  steps {
   git branch: 'main',
    url: 'https://github.com/oumaima-boubaker/maven_pipeline_project.git'
  }
 }
       stage ('Compile Stage') {

            steps {
                withMaven(maven : 'Maven 3.8.5') {
                    sh 'mvn clean compile'
                }
            }
        }
         stage ('Testing Stage') {

            steps {
                withMaven(maven : 'Maven 3.8.5') {
                    sh 'mvn test'
                }
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean package'
            }
         }
         stage ('Sonarqube analysis'){
              steps {
                   withSonarQubeEnv('SonarQube') {
                        sh "mvn sonar:sonar"
                   }
              }
         }
         stage('Quality Gate Check'){
     
            steps
         {
            
                waitForQualityGate abortPipeline: true, credentialsId: 'SONARQUBE_TOKEN1'
            
         }
     }
      stage('Nexus Upload')
     {
         steps
         {
             script
             {
                 def readPom = readMavenPom file: 'pom.xml'
                 def nexusrepo = readPom.version.endsWith("SNAPSHOT") ? "SnapshotNexusRepository" : "NexusRepository"
                 nexusArtifactUploader artifacts: 
                 [
                     [
                         artifactId: "${readPom.artifactId}",
                         classifier: '', 
                         file: "target/${readPom.artifactId}-${readPom.version}.war", 
                         type: 'war'
                     ]
                ], 
                         credentialsId: 'jenkins-nexus', 
                         groupId: "${readPom.groupId}", 
                         nexusUrl: '192.168.1.46:8081', 
                         nexusVersion: 'nexus3', 
                         protocol: 'http', 
                         repository: "${nexusrepo}", 
                         version: "${readPom.version}"

             }
         }
     }
}
}
