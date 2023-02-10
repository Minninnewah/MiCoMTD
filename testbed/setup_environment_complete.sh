read -p 'Master or worker? [m/w]: ' role
if [  $role == "m"  ]; then
        echo "Set up Master node"
        read -p 'Local ip address range of the worker nodes to set up the nfs server (like 10.0.0.0/16): ' workerRange
elif [ $role == "w" ]; then
        echo "Set up Worker node"
        read -p 'Enter join command from master node (kubeadm join ...): ' joinCommand
        read -p 'Enter local ip of master node (like 10.0.0.34: ' masterIP
else
        echo "Abort, Inacceptable selection"
        exit 0
fi

wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_basic_2.sh | bash


if [  $role == "m"  ]; then
        echo "Master specific setup"
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_master.sh | bash /dev/stdin -r $workerRange
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_openvpn.sh | bash
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_server_controller.sh | bash
elif [ $role == "w" ]; then
        echo "Worker specific setup"
        echo "Joint to master noder"
        sudo $joinCommand --ignore-preflight-errors=all # ingore error because preflight test are done with kubernetes 1.26 which does not suppport this containerd version
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_worker.sh | bash /dev/stdin -h $masterIP
fi
        
