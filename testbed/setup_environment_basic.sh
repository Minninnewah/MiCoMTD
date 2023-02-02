#!/bin/bash

# Init K8s cluster
sudo apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli docker-compose-plugin -y
sudo apt-get autoremove -y --purge docker docker-engine docker.io docker-ce docker-ce-cli docker-compose-plugin
sudo rm -f /var/run/docker.sock
sudo rm -rf /var/lib/docker /etc/docker

# step 1
echo "Step 1"
echo "Download containerd and unpackage"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install gcc -y #popup

mkdir tmp
cd tmp/
sudo wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
sudo tar -xzf go1.15.5.linux-amd64.tar.gz
sudo mv go /usr/local
#sudo vi $HOME/.profile
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/go' >> $HOME/.profile
echo 'export GOBIN=$GOPATH/bin' >> $HOME/.profile
echo 'export PATH=$GOROOT/bin:$GOBIN:$PATH' >> $HOME/.profile
#echo 'export PATH="/usr/bin:$PATH"' >> $HOME/.profile
#echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> $HOME/.profile
source $HOME/.profile
go version

sudo DEBIAN_FRONTEND=noninteractive apt install make -y #popup
wget https://github.com/containerd/containerd/releases/download/v1.3.6/containerd-1.3.6-linux-amd64.tar.gz
mkdir containerd
tar -xvf containerd-1.3.6-linux-amd64.tar.gz -C containerd
sudo mv containerd/bin/* /bin/


#Replace containerrd-cri with version supporting CRIU
echo "Replace the containerd-cri with interface extentions supporting CRIU"
#git clone https://github.com/vutuong/containerd-cri.git
#cd containerd-cri/
#go version
#go get github.com/containerd/cri/cmd/containerd
#make
#sudo chown -R root:root /home/ubuntu/tmp/containerd-cri
#sudo DEBIAN_FRONTEND=noninteractive apt install golang-go -y
#sudo make install # comment -> unsafe repo is owne dby someone else
#cd _output/
#sudo mv containerd /bin/
cd containerd/
wget https://k8s-pod-migration.obs.eu-de.otc.t-systems.com/v2/containerd
git clone https://github.com/SSU-DCN/podmigration-operator.git
cd podmigration-operator
tar -vxf binaries.tar.bz2
cd custom-binaries/
chmod +x containerd
sudo mv containerd /bin/

#Configure containerd and create the containerd configuration file
echo "Configure containerd and create the containerd configuration file"
sudo mkdir /etc/containerd #already existsls /etc
sudo rm /etc/containerd/config.toml
sudo touch /etc/containerd/config.toml
echo '[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""' | sudo tee /etc/containerd/config.toml >/dev/null

# Install newest version of runc
echo "Install newest version of runc"
cd $HOME/tmp
mkdir runc
cd runc
wget https://github.com/opencontainers/runc/releases/download/v1.0.0-rc92/runc.amd64
whereis runc
sudo mv runc.amd64 runc
chmod +x runc
sudo mv runc /usr/local/bin/

# Configure containerd and create the containerd.service systemd unit file
echo "Configure containerd"
echo '[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/containerd.service >/dev/null

# Reload containerd service
echo "Reload containerd service"
sudo systemctl daemon-reload
sudo systemctl restart containerd
#sudo systemctl status containerd

# Step 2
echo "Step 2"
echo "Solve a few problems with containerd"
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.conf >/dev/null
sudo -s << SCRIPT
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
exit
SCRIPT
echo $HOME
sudo sysctl --system #perhaps an error
sudo modprobe overlay
sudo modprobe br_netfilter

# Step 4
echo "Step 4"
echo "Install kubernetes components"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add #deprecated
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install kubeadm=1.19.0-00 kubelet=1.19.0-00 kubectl=1.19.0-00 -y
whereis kubeadm
whereis kubelet

#Step 5
cd $HOME/tmp
git clone https://github.com/vutuong/kubernetes.git
git clone https://github.com/SSU-DCN/podmigration-operator.git
cd podmigration-operator
tar -vxf binaries.tar.bz2
cd custom-binaries

chmod +x kubeadm kubelet
sudo mv kubeadm kubelet /usr/bin/
sudo systemctl daemon-reload
sudo systemctl restart kubelet
