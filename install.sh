#!/bin/bash -e

apt-get clean
mv /var/lib/apt/lists/* /tmp
mkdir -p /var/lib/apt/lists/partial
mkdir -p /etc/drydock
apt-get clean
apt-get update

echo "================= Installing basic packages ===================="
apt-get update && apt-get install -y \
sudo \
software-properties-common \
wget \
curl \
unzip \
openssh-client \
ftp \
gettext \
smbclient

echo "================= Installing Python packages =================="
apt-get install -q -y \
python-pip \
python2.7-dev

pip install -q virtualenv==16.5.0
pip install -q pyOpenSSL==19.0.0


export JQ_VERSION=1.5*
echo "================= Adding JQ $JQ_VERSION ========================="
apt-get install -y -q jq="$JQ_VERSION"

echo "================= Installing CLIs packages ======================"

export GIT_VERSION=1:2.*
echo "================= Installing Git $GIT_VERSION ===================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y -q git="$GIT_VERSION"

export CLOUD_SDKREPO=249.0*
echo "================= Adding gcloud $CLOUD_SDK_REPO =================="
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get -y install google-cloud-sdk="$CLOUD_SDKREPO"

export AWS_VERSION=1.16.173
echo "================= Adding awscli $AWS_VERSION ===================="
sudo pip install awscli=="$AWS_VERSION"

export AWSEBCLI_VERSION=3.15.2
echo "================= Adding awsebcli $AWSEBCLI_VERSION =============="
sudo pip install awsebcli=="$AWSEBCLI_VERSION"

AZURE_CLI_VERSION=2.0*
echo "================ Adding azure-cli $AZURE_CLI_VERSION =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install -q apt-transport-https
sudo apt-get update && sudo apt-get install -y -q azure-cli=$AZURE_CLI_VERSION

JFROG_VERSION=1.25.0
echo "================= Adding jfrog-cli $JFROG_VERSION  ================"
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

GRADLE_VERSION="5.4.1"
echo "================ Installing gradle "$GRADLE_VERSION"  ================="
wget -nv https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip
unzip -qq gradle-$GRADLE_VERSION-all.zip -d /usr/local && rm -f gradle-$GRADLE_VERSION-all.zip
ln -fs /usr/local/gradle-$GRADLE_VERSION/bin/gradle /usr/bin
echo 'export PATH=$PATH:/usr/local/gradle-$GRADLE_VERSION/bin' >> /etc/drydock/.env

APACHE_MAVEN="3.6.1"
echo "================ Installing apache-maven "$APACHE_MAVEN" ================="
wget -nv https://www-us.apache.org/dist/maven/maven-3/$APACHE_MAVEN/binaries/apache-maven-$APACHE_MAVEN-bin.tar.gz
tar xzf apache-maven-$APACHE_MAVEN-bin.tar.gz -C /usr/local && rm -f apache-maven-$APACHE_MAVEN-bin.tar.gz
ln -fs /usr/local/apache-maven-$APACHE_MAVEN/bin/mvn /usr/bin
echo 'export PATH=$PATH:/usr/local/apache-maven-$APACHE_MAVEN/bin' >> /etc/drydock/.env


APACHE_ANT=1.10.6
echo "================ Installing apache-ant "$APACHE_ANT" ================="
wget -nv https://archive.apache.org/dist/ant/binaries/apache-ant-$APACHE_ANT-bin.tar.gz
tar xzf apache-ant-$APACHE_ANT-bin.tar.gz -C /usr/local && rm -f apache-ant-$APACHE_ANT-bin.tar.gz
ln -fs /usr/local/apache-ant-$APACHE_ANT/bin/ant /usr/bin
echo 'export ANT_HOME=/usr/local/apache-ant-$APACHE_ANT' >> /etc/drydock/.env
echo 'export PATH=$PATH:/usr/local/apache-ant-$APACHE_ANT/bin' >> /etc/drydock/.env

echo "deb http://security.ubuntu.com/ubuntu bionic main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update

for file in /u18java/version/*;
do
  $file
done
