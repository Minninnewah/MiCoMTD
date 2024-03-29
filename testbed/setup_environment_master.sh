#-r param is for the local ip address range of the worker nodes like 10.0.0.0/16
if [ $# -ne 2 ]; then
   echo "Only one flag allowed";
   exit;
fi

if [ "$1" != "-r" ]; then
  echo "Only -r flag supported"
  exit;
fi

while getopts r: flag
do
        case "${flag}" in
                r) range=${OPTARG};;
        esac
done

source $HOME/.profile

#ignore errors because of Kubernetes 1.26 which does not support this containerd version anymore but this version is used for the preflight tests.
echo "Setup kubeadm"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Apply flannel CNI add-on network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods -n kube-system


sudo mkdir /var/lib/kubelet/migration
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install nfs-kernel-server -y
echo "/var/lib/kubelet/migration/  $range(rw,sync,no_subtree_check)" | sudo tee /etc/exports >/dev/null
sudo exportfs -arvf
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
sudo systemctl status nfs-kernel-server
sudo chmod 777 /var/lib/kubelet/
sudo chmod 777 /var/lib/kubelet/migration

cd $HOME/tmp/podmigration-operator/kubectl-plugin/checkpoint-command
go build -o kubectl-checkpoint
sudo cp kubectl-checkpoint /usr/local/bin

cd $HOME/tmp/podmigration-operator/kubectl-plugin/migrate-command
go build -o kubectl-migrate
sudo cp kubectl-migrate /usr/local/bin

