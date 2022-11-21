Set up kubernetes nodes (cluster) accordingly to the [podmigration-operator repository](https://github.com/SSU-DCN/podmigration-operator) with own containerd and containerd-cri version. Interactive script:
```
bash <(wget -qO- https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/testbed/setup_environment_complete.sh )
```

The script request all neccessary information at the beginning of the script:

Worker or Master?<br />
* [w]<br />
  * [join command of master]<br />
  * [ip adress of master (for nfs mount)]<br />
* [m]<br />
  * [local ip address range of workers (to set nfs permissions)]<br />
