#Not yet tested

#default microk8s installation
sudo apt install snapd -y
sudo snap install microk8s --classic
sudo usermod -a -G microk8s `whoami`
newgrp microk8s
microk8s.status --wait-ready
microk8s.enable dns
