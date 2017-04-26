#!/bin/bash
service ssh start

if [ ! -d "/home/site/conf" ]; then
	echo "Info: Tomcat configuration directory is not available. Creating one"
	mkdir -p /home/site/conf
	cp -R /usr/local/tomcat/conf/. /home/site/conf/
	rm -f /usr/local/tomcat/conf 
	ln -s /home/site/conf /usr/local/tomcat/conf
else
	echo "Info: Tomcat configuration directory already exists"
fi

cd /home/site/wwwroot

wget https://raw.githubusercontent.com/sureddy1/appsvc-tomcat/master/apps/ROOT.war
wget https://raw.githubusercontent.com/sureddy1/appsvc-tomcat/master/apps/examples.war
wget https://raw.githubusercontent.com/sureddy1/appsvc-tomcat/master/apps/host-manager.war
wget https://raw.githubusercontent.com/sureddy1/appsvc-tomcat/master/apps/manager.war
wget https://raw.githubusercontent.com/sureddy1/appsvc-tomcat/master/apps/docs.war

/usr/local/tomcat/bin/catalina.sh run