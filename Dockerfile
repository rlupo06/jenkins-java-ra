FROM ubuntu:16.04

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
openjdk-8-jdk \
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

#===============
# Install Docker
#===============
RUN apt-get update
RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update
RUN apt-get -y install docker-ce

#===============
# Set DOCKER_HOST
#===============
ENV DOCKER_HOST=tcp://192.168.0.40:2375

