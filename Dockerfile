FROM ubuntu:15.04
MAINTAINER Sebastien Langoureaux <linuxworkgroup@hotmail.com>
 
ENV NODEJS_VERSION 0.12.7
ENV NVM_VERSION 0.25.4
ENV NVM_DIR /usr/local/nvm
ENV INTELLIJ_VERSION 14.1.4
ENV TOMCAT_VERSION 7.0.64

 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
 

 
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install software-properties-common gcc make build-essential -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales
 
# Install Nodejs, Java, Maven, Git, terminal, etc.
RUN apt-get install nodejs nodejs-dev nodejs-legacy npm curl maven openjdk-7-jdk python2.7 python2.7-dev mysql-client python-pip python-virtualenv python-tox libffi-dev coreutils xfce4-terminal git unzip -y
 
 
# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install ${NODEJS_VERSION} \
    && nvm alias default ${NODEJS_VERSION} \
    && nvm use default
 
ENV NODE_PATH $NVM_DIR/versions/node/v${NODEJS_VERSION}/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin:$PATH
RUN ln -s $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin/node $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin/nodejs
 
RUN npm update -g
 
# Upgrade nodejs lib
RUN npm install -g async
 
# Install npm module
RUN npm install -g yo bower grunt-cli gulp ember-cli watchman
 
 
# Install IntelliJ IDEA Ultimate
RUN curl http://download.jetbrains.com/idea/ideaIU-${INTELLIJ_VERSION}.tar.gz -Lo "/tmp/intellij.tar.gz"
RUN mkdir -p /opt/intellij
RUN tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij
RUN rm /tmp/intellij.tar.gz
RUN ln -s /opt/intellij/bin/idea.sh /usr/bin/idea

# Install Tomcat 8 to use it with intellij
RUN curl http://mirrors.ircam.fr/pub/apache/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -Lo "/tmp/tomcat.tar.gz"
RUN mkdir -p /opt/tomcat
RUN tar -xf /tmp/tomcat.tar.gz --strip-components=1 -C /opt/tomcat
RUN rm /tmp/tomcat.tar.gz
 
 
# CLEAN APT
RUN rm -rf /var/lib/apt/lists/*
 
 
# Create user and folder to work
RUN useradd -m dev
 
USER dev
 

WORKDIR /home/dev

# Clone and init rancher-ui
# Launch manually the following command when you mount the volume
#RUN git clone 'https://github.com/rancher/ui'
#WORKDIR /home/dev/workspace/ui
#RUN git submodule init
#RUN git submodule update
#RUN npm install
#RUN bower install
#WORKDIR /home/dev/workspace/

# Clone and init cattle
#RUN git clone https://github.com/rancherio/cattle.git

# Clone and init python-agent
#RUN git clone https://github.com/rancher/python-agent.git
#WORKDIR /home/dev/workspace/python-agent
#RUN mkdir venv && virtualenv venv && . venv/bin/activate
#RUN pip install -r requirements.txt
#RUN pip install -r test-requirements.txt
#WORKDIR /home/dev/workspace/



 
EXPOSE 8080
EXPOSE 8000
 
VOLUME ["/home/dev/"]
 
CMD ["idea"]
