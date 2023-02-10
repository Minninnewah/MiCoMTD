#sudo apt update
#sudo apt upgrade -y
#sudo apt install git zip curl unzip python3 -y
#
#git clone https://gerrit.onosproject.org/onos
#cd onos
#cat << EOF >> ~/.bash_profile
#export ONOS_ROOT="`pwd`"
#source $ONOS_ROOT/tools/dev/bash_profile
#EOF
#. ~/.bash_profile
#
##install brazel
#sudo apt install apt-transport-https curl gnupg -y
#curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
#sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
#
#sudo apt update && sudo apt install bazel-6.0.0-pre.20220421.3 -y
#
#sudo apt update && sudo apt full-upgrade
#
##install jdk -> used if you want to build java code
#sudo apt install openjdk-8-jdk -y
#
#
##Build onos
#cd $ONOS_ROOT
#bazel build onos
#
## Start onos
## bazel run onos-local [-- [clean] [debug]] # if not loaded bash profile
#ok

# Offical website
#Requirements
sudo adduser sdn --system --group
sudo apt install openjdk-8-jdk #originally this would be java8 from oracle
sudo apt install openjdk-11-jdk
sudo apt-get install curl

sudo mkdir /opt
cd /opt
sudo wget -c https://repo1.maven.org/maven2/org/onosproject/onos-releases/2.7.0/onos-2.7.0.tar.gz
sudo tar xzf onos-2.7.0.tar.gz
sudo mv onos-2.7.0 onos
sudo /opt/onos/bin/onos-service start



for JavaCommand in java jar java2groovy javac javadoc javafxpackager javah javap javapackager javaws
do
    sudo update-alternatives --install /usr/bin/$JavaCommand $JavaCommand /home/ubuntu/jdk1.8.0_361/bin/$JavaCommand 1
done