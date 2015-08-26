# Docker file to create Jenkins container.

FROM cgswong/java:orajdk8
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Setup environment
ENV JENKINS_VERSION %%VERSION%%
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins
ENV JENKINS_HOME /opt/jenkins
ENV JENKINS_VOL /var/lib/jenkins

# Install software
RUN apk update &&\
    apk upgrade &&\
    mkdir -p $JENKINS_HOME $JENKINS_VOL/plugins $JAVA_BASE &&\
    curl --silent --insecure --location --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar zxf - -C $JAVA_BASE &&\
    ln -s $JAVA_BASE/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} &&\
    curl --silent --location http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war --output ${JENKINS_HOME}/jenkins.war &&\
    addgroup ${JENKINS_GROUP} &&\
    adduser -h ${JENKINS_HOME} -D -s /bin/bash -G ${JENKINS_GROUP} ${JENKINS_USER} &&\
    chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME} ${JENKINS_VOL} &&\
    for plugins in credentials ssh-credentials ssh-agent ssh-slaves git-client git github github-api github-oauth ghprb scm-api postbuild-task greenballs; do  curl --silent --location --insecure http://updates.jenkins-ci.org/latest/${plugins}.hpi --output $JENKINS_PLUGINS/${plugins}.hpi; done


# Listen for main web interface (8080/tcp) and attached slave agents (50000/tcp)
EXPOSE 8080 50000

# Expose volumes
VOLUME ["${JENKINS_VOL}"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER ${JENKINS_USER}

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [""]
