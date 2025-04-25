#!/bin/bash

set -e

if [ "$1" = 'sonar' ]; then
    # Configure database if JDBC_URL is set
    if [ -n "$SONARQUBE_JDBC_URL" ]; then
        sed -i "/^#sonar.jdbc.url=/c\sonar.jdbc.url=$SONARQUBE_JDBC_URL" ${SONARQUBE_HOME}/conf/sonar.properties
        sed -i "/^#sonar.jdbc.username=/c\sonar.jdbc.username=$SONARQUBE_JDBC_USERNAME" ${SONARQUBE_HOME}/conf/sonar.properties
        sed -i "/^#sonar.jdbc.password=/c\sonar.jdbc.password=$SONARQUBE_JDBC_PASSWORD" ${SONARQUBE_HOME}/conf/sonar.properties
    fi

    # Start SonarQube
    exec ${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh console
fi

exec "$@"
