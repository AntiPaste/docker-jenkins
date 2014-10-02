#FROM java:openjdk-7u65-jdk
FROM java:7u65
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Install necessary software prerequisites
RUN apt-get update && apt-get install -y wget git curl zip && rm -rf /var/lib/apt/lists/*

# To maintain consistency this is version specific
# Should this be latest (1.583) instead?
##ENV JENKINS_VERSION latest
ENV JENKINS_VERSION 1.565.3

# Createa user
RUN mkdir /usr/share/jenkins/
RUN useradd -d /home/jenkins -m -s /bin/bash jenkins

COPY init.groovy /tmp/WEB-INF/init.groovy
RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
  && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy && rm -rf /tmp/WEB-INF

ENV JENKINS_HOME /var/jenkins_home
RUN usermod -m -d "$JENKINS_HOME" jenkins && chown -R jenkins "$JENKINS_HOME"
VOLUME /var/jenkins_home

# define url prefix for running jenkins behind Apache (https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
ENV JENKINS_PREFIX /

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

USER jenkins

ENTRYPOINT java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war --prefix=$JENKINS_PREFIX
