#!/bin/bash

set -eo pipefail
ln -s /opt/jenkins-plugins /opt/jenkins/plugins

# If there are any arguments then we want to run those instead
if [[ "$1" == "-"* || -z $1 ]]; then
  exec java -jar /jenkins.war "$@"
else
  exec "$@"
fi
