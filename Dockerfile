FROM tomcat:8.0.20-jre8
COPY target/maven_pipeline_project*.war /usr/local/tomcat/webapps/maven_pipeline_project.war