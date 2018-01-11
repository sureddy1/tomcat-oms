#!/bin/bash
service ssh start

sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/opt/microsoft/omsagent/sysconf/omsagent.d/container.conf
sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/opt/microsoft/omsagent/sysconf/omsagent.d/syslog.conf
sed -i -e 's/^exit 101$/exit 0/g' /usr/sbin/policy-rc.d

sed -i.bak "s/record\[\"Host\"\] = hostname/record\[\"Host\"\] = OMS::Common.get_hostname/" /opt/microsoft/omsagent/plugin/filter_syslog.rb


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
