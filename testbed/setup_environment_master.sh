echo "Setup kubeadm"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Apply flannel CNI add-on network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods -n kube-system


sudo mkdir /var/lib/kubelet/migration
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install nfs-kernel-server -y
echo '/var/lib/kubelet/migration/  10.0.0.0/16(rw,sync,no_subtree_check)' | sudo tee /etc/exports >/dev/null
sudo exportfs -arvf
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
sudo systemctl status nfs-kernel-server
sudo chmod 777 /var/lib/kubelet/
sudo chmod 777 /var/lib/kubelet/migration
