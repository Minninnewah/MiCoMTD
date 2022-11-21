read -p 'Master or worker? [m/w]: ' role
if [  $role == "m"  ]; then
        echo "Set up Master node"
        read -p 'Local ip address range of the worker nodes to set up the nfs server (like 10.0.0.0/16): ' workerRange
elif [ $role == "w" ]; then
        echo "Set up Worker node"
        read -p 'Enter join command from master node: ' joinCommand
        read -p 'Enter local ip of master node: ' masterIP
else
        echo "Abort, Inacceptable selection"
        exit 0
fi

wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_basic.sh | bash


if [  $role == "m"  ]; then
        echo "Master specific setup"
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_master.sh | bash /dev/stdin -r $workerRange
elif [ $role == "w" ]; then
        echo "Worker specific setup"
        echo "Joint to master noder"
        $joinCommand
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_worker.sh | bash /dev/stdin -h $masterIP
fi
        
