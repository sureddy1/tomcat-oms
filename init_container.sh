#!/bin/bash
service ssh start

echo exit 0 > /usr/sbin/policy-rc.d

wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh
sh onboard_agent.sh -w ec95873b-d48d-4287-9111-0e83093ea0ad -s SqTZZ5WNbphmU16A4Jf+2pQy/71FURgehST/ghSltYFB6ixKMaWF+CD4OIjKb8+mYTWvc+ylMX9hrWL21kGJkQ== -d opinsights.azure.com &

if [ ! -d "/home/site/conf" ]; then
	echo "Info: Tomcat configuration directory is not available. Creating one"
	mkdir -p /home/site/conf
	cp -R /usr/local/tomcat/conf/. /home/site/conf/	
else
	echo "Info: Tomcat configuration directory already exists"
fi

rm -rf /usr/local/tomcat/conf 
ln -s /home/site/conf /usr/local/tomcat/conf

chown -R root:root /home/site/conf

cd /home/site/wwwroot

test ! -e "ROOT.war" && wget -O ROOT.war https://raw.githubusercontent.com/sureddy1/tomcat-oms/master/apps/ROOT.war
test ! -e "examples.war" && wget -O examples.war https://raw.githubusercontent.com/sureddy1/tomcat-oms/master/apps/examples.war
test ! -e "host-manager.war" && wget -O host-manager.war https://raw.githubusercontent.com/sureddy1/tomcat-oms/master/apps/host-manager.war
test ! -e "manager.war" && wget -O manager.war https://raw.githubusercontent.com/sureddy1/tomcat-oms/master/apps/manager.war
test ! -e "docs.war" && wget -O docs.war https://raw.githubusercontent.com/sureddy1/tomcat-oms/master/apps/docs.war

/usr/local/tomcat/bin/catalina.sh run
