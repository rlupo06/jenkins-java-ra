FROM openjdk:8-jdk

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
curl \
unzip \
apt-transport-https \
ca-certificates \
software-properties-common


#===============
# Set JAVA_HOME
#===============
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    PATH=$PATH:$JAVA_HOME/bin

#================
# Install Gradle
#================
RUN \
    cd /usr/local && \
    curl -L https://services.gradle.org/distributions/gradle-4.9-bin.zip -o gradle-4.9-bin.zip && \
    unzip gradle-4.9-bin.zip && \
    rm gradle-4.9-bin.zip

#================
# Install git
#================
RUN apt-get install --assume-yes git

#===================
# Install Jenkins RA
#===================
ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.23"

ARG VERSION=3.23
ARG AGENT_WORKDIR=/home/${user}/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}



#===============
# Install Docker
#===============
RUN apt-get update
RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update
RUN apt-get -y install docker-ce


