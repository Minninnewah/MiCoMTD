#-h param is for the ip address of the master
if [ $# -ne 2 ]; then
   echo "Only one flag allowed";
   exit;
fi

if [ "$1" != "-h" ]; then
  echo "Only -h flag supported"
  exit;
fi

while getopts h: flag
do
        case "${flag}" in
                h) ip=${OPTARG};;
        esac
done
echo "IP: $ip";

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
sudo make #Didn't need the sude the first time
sudo make install
sudo criu check
sudo criu check --all
sudo mkdir /etc/criu
sudo touch /etc/criu/runc.conf
echo 'tcp-established
tcp-close' | sudo tee /etc/criu/runc.conf >/dev/null


echo "Configure NFS share folder"
sudo apt-get update
sudo mkdir /var/lib/kubelet/migration
sudo chmod 777 /var/lib/kubelet/
sudo chmod 777 /var/lib/kubelet/migration
sudo DEBIAN_FRONTEND=noninteractive apt-get install nfs-common -y
sudo mount -t nfs -o nfsvers=3 $ip:/var/lib/kubelet/migration /var/lib/kubelet/migration

echo "Install migrate/nsapshot plugin"
cd $HOME/tmp
cd podmigration-operator
cd kubectl-plugin/
cd checkpoint-command
go build -o kubectl-checkpoint
sudo cp kubectl-checkpoint /usr/local/bin

cd ..
cd migrate-command
go build -o kubectl-migrate
sudo cp kubectl-migrate /usr/local/bin
