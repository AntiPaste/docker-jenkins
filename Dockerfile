# Docker file to create Jenkins container.

FROM cgswong/java:orajre8
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Setup environment
ENV JENKINS_VERSION 1.647
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins
ENV JENKINS_HOME /opt/jenkins

# Install software
RUN apk update && \
    apk upgrade && \
    mkdir -p $JENKINS_HOME/plugins $JAVA_BASE && \
    curl -sSL http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war --output ${JENKINS_HOME}/jenkins.war && \
    addgroup ${JENKINS_GROUP} && \
    adduser -h ${JENKINS_HOME} -D -s /bin/bash -G ${JENKINS_GROUP} ${JENKINS_USER} && \
    chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME} && \
    for plugins in credentials ssh-credentials ssh-agent ssh-slaves git-client git github github-api github-oauth ghprb scm-api postbuild-task greenballs; do curl -sSL http://updates.jenkins-ci.org/latest/${plugins}.hpi --output $JENKINS_HOME/plugins/${plugins}.hpi; done

# Listen for main web interface (8080/tcp) and attached slave agents (50000/tcp)
EXPOSE 8080 50000

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER ${JENKINS_USER}

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [""]
