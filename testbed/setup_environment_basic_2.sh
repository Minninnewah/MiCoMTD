#!/bin/bash

# Init K8s cluster

# step 1
echo "*** Step 1 ***"
echo "---Download containerd and unpackage---"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install gcc -y

mkdir tmp
cd tmp/
sudo wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
sudo tar -xzf go1.15.5.linux-amd64.tar.gz
sudo mv go /usr/local
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/go' >> $HOME/.profile
echo 'export GOBIN=$GOPATH/bin' >> $HOME/.profile
echo 'export PATH=$GOROOT/bin:$GOBIN:$PATH' >> $HOME/.profile
source $HOME/.profile
go version


#Setup developer environment
echo "---Setup developer environment---"
cd $HOME
sudo DEBIAN_FRONTEND=noninteractive apt install make -y
sudo apt-get install unzip
wget -c https://github.com/google/protobuf/releases/download/v3.5.0/protoc-3.5.0-linux-x86_64.zip
sudo unzip protoc-3.5.0-linux-x86_64.zip -d /usr/local
sudo DEBIAN_FRONTEND=noninteractive apt-get install btrfs-tools
sudo DEBIAN_FRONTEND=noninteractive apt install libseccomp-dev

## Compile and install containerd
echo "---Compile and install containerd---"
mkdir go
cd go 
mkdir src
cd $GOPATH/src
mkdir github.com
cd github.com
mkdir containerd
cd containerd
git clone --branch extended_snapshot https://github.com/Minninnewah/containerd.git
cd containerd
make
sudo mv bin/* /bin/

#just add it to the other folder
#wget https://github.com/containerd/containerd/releases/download/v1.3.6/containerd-1.3.6-linux-amd64.tar.gz
#mkdir containerd
#tar -xvf containerd-1.3.6-linux-amd64.tar.gz -C containerd
##sudo mv containerd/bin/* /bin/

#Replace containerrd-cri with version supporting CRIU
echo "---Replace the containerd-cri with interface extentions supporting CRIU---"

# Error whilemigrating
#cd $HOME/tmp
#git clone https://github.com/Minninnewah/containerd-cri
#cd containerd-cri/
#go get github.com/containerd/cri/cmd/containerd  #Not sure about this step or if i need to use my own girhub repo again
#make
##sudo make install
#sudo -E env "PATH=$PATH" make install
#cd _output/
#chmod +x containerd
#sudo mv containerd /bin/

#With this is works (precompiled cri-containerd)
cd containerd/ #additional
wget https://k8s-pod-migration.obs.eu-de.otc.t-systems.com/v2/containerd
git clone https://github.com/SSU-DCN/podmigration-operator.git
cd podmigration-operator
tar -vxf binaries.tar.bz2
cd custom-binaries/
chmod +x containerd
sudo mv containerd /bin/

#Configure containerd and create the containerd configuration file
echo "---Configure containerd and create the containerd configuration file---"
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
echo "---Install newest version of runc---"
cd $HOME/tmp
mkdir runc
cd runc
wget https://github.com/opencontainers/runc/releases/download/v1.0.0-rc92/runc.amd64
whereis runc
sudo mv runc.amd64 runc
chmod +x runc
sudo mv runc /usr/local/bin/

# Configure containerd and create the containerd.service systemd unit file
echo "---Configure containerd---"
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
echo "---Reload containerd service---"
sudo systemctl daemon-reload
sudo systemctl restart containerd
#sudo systemctl status containerd

# Step 2
echo "*** Step 2 ***"
echo "---Solve a few problems with containerd---"
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
echo "*** Step 4 ***"
echo "---Install kubernetes components---"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add #deprecated
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install kubeadm=1.19.0-00 kubelet=1.19.0-00 kubectl=1.19.0-00 -y
whereis kubeadm
whereis kubelet

#Step 5
echo "*** step 5 ***"
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
#sudo systemctl status kubelet

##Step 5
#echo "Step 5"
#echo "Kubernetes custom source code"
##curl -L https://github.com/coreos/etcd/releases/download/v3.0.17/etcd-v3.0.17-linux-amd64.tar.gz -o etcd-v3.0.17-linux-amd64.tar.gz && tar xzvf etcd-v3.0.17-linux-amd64.tar.gz && sudo /bin/cp -f etcd-v3.0.17-linux-amd64/{etcd,etcdctl} /usr/bin && rm -rf etcd-v3.0.17-linux-amd64*
#cd $HOME/tmp
#cd containerd #in tpm
#
## Get kubernetes source code
#git clone https://github.com/vutuong/kubernetes.git
#
## Add kubernetes source code to GOPATH
#git clone https://github.com/vutuong/kubernetes.git $GOPATH/src/k8s.io/kubernetes
#cd $GOPATH/src/k8s.io/kubernetes
#hack/install-etcd.sh
#export KUBERNETES_PROVIDER=local # errors
#
## old golang version
#sudo apt-get --purge remove golang-go -y
#cd $HOME/tmp
#sudo tar -xzf go1.15.5.linux-amd64.tar.gz
#sudo rm -rf /usr/local/go
#sudo mv go /usr/local
#cd $GOPATH/src/k8s.io/kubernetes
#
#make # -> no errors
## time make quick-release
##hack/local-up-cluster.sh
#
#
## Step 6
#echo "Step 6"
#echo "Replace kubelet with custom kubelet"
#cd $HOME/tmp
#git clone https://github.com/SSU-DCN/podmigration-operator.git
#cd podmigration-operator
#tar -vxf binaries.tar.bz2
#cd custom-binaries
#
#chmod +x kubeadm kubelet
#sudo mv kubeadm kubelet /usr/bin/
#sudo systemctl daemon-reload
#sudo systemctl restart kubelet
#sudo systemctl status kubelet
