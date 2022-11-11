read -p 'Master or worker? [m/w]: ' role
if [  $role == "m"  ]; then
        echo "Set up Master node"
elif [ $role == "w" ]; then
        echo "Set up Worker node"
        read -p 'Enter join command from master node: ' joinCommand
else
        echo "Abort, Inacceptable selection"
fi

wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_basic.sh | bash


if [  $role == "m"  ]; then
        echo "Master specific setup"
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_master.sh | bash
elif [ $role == "w" ]; then
        echo "Worker specific setup"
        echo "Joint to master noder"
        $joinCommand
        wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_worker.sh | bash
        
        
