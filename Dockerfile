FROM ubuntu:16.04

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
curl \
unzip \
apt-transport-https \
ca-certificates \
software-properties-common

#===============
# Install Java
#===============
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

#===============
# Set JAVA_HOME
#===============
ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle" \
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

#===============
# Install Docker
#===============
RUN apt-get update
RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update
RUN apt-get -y install docker-ce




