echo "Install CRIU"
cd $HOME/tmp
cd podmigration-operator
tar -vxf criu-3.14.tar.bz2
cd criu-3.14

sudo DEBIAN_FRONTEND=noninteractive apt-get install protobuf-c-compiler libprotobuf-c0-dev protobuf-compiler \
libprotobuf-dev:amd64 gcc build-essential bsdmainutils python git-core \
asciidoc make htop git curl supervisor cgroup-lite libapparmor-dev \
libseccomp-dev libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler \
protobuf-compiler python-protobuf libnl-3-dev libcap-dev libaio-dev \
apparmor libnet1-dev libnl-genl-3-dev libnl-route-3-dev libnfnetlink-dev pkg-config -y

make clean
make
sudo make install
sudo criu check
sudo criu check --all
sudo mkdir /etc/criu
sudo touch /etc/criu/runc.conf
echo 'tcp-established
tcp-close' | sudo tee /etc/criu/runc.conf >/dev/null


echo "Configure NFS share folder"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install nfs-common -y
sudo mount -t nfs -o nfsvers=3 10.10.3.124:/var/lib/kubelet/migration /var/lib/kubelet/migration
