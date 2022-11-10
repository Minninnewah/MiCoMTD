sudo mkdir /var/lib/kubelet/migration
sudo apt-get update
sudo apt-get install nfs-kernel-server -y
echo '/var/lib/kubelet/migration/  192.168.10.0/24(rw,sync,no_subtree_check)' | sudo tee /etc/exports >/dev/null
sudo exportfs -arvf
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
sudo systemctl status nfs-kernel-server
sudo chmod 777 /var/lib/kubelet/migration
