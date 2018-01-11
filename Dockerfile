FROM tomcat:8.0.48-jre7

COPY init_container.sh /bin/

RUN apt-get update \
	&& apt install -y --no-install-recommends \
		openssh-server \
	&& apt install -y vim \
	&& apt install -y python-ctypes \
	&& apt install -y sudo \
	&& chmod 755 /bin/init_container.sh \
	&& echo "root:Docker!" | chpasswd 
	
RUN rm -fr /usr/local/tomcat/webapps \
    && rm -fr /usr/local/tomcat/logs \

    && ln -s /home/site/wwwroot /usr/local/tomcat/webapps \
    && ln -s /home/LogFiles /usr/local/tomcat/logs \
	&& chmod 777 /bin/init_container.sh 
	
COPY sshd_config /etc/ssh/

EXPOSE 2222	

EXPOSE 8080

CMD ["/bin/init_container.sh"]
