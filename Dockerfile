FROM tomcat:8

# Mention some Meta data
LABLE maintainer='ItsMyDevOps'\
      version =1.0.0

# Take the war and copy to webapps of tomcat
COPY target/*.war /usr/local/tomcat/webapps/
