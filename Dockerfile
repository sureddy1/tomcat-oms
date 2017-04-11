FROM tomcat:9.0.0-jre8

rm -fr /usr/local/tomcat/webapps
rm -fr /usr/local/tomcat/logs

ln -s /home/site/wwwroot /usr/local/tomcat/webapps
ln -s /home/LogFiles /usr/local/tomcat/logs

EXPOSE 8080
CMD ["catalina.sh", "run"]
