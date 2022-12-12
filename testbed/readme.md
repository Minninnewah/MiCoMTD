Set up kubernetes nodes (cluster) accordingly to the [podmigration-operator repository](https://github.com/SSU-DCN/podmigration-operator) with own containerd and containerd-cri version

1. (Remove old fingerporint)
ssh-keygen -R 160.85.253.79

2. ssh connection
ssh ubuntu@<ip> -i <pathToKeyFile>


Interactive script:
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


## Migration
 
1. Use source
```
source $HOME/.profile
```
2. run video pod
```
cd tmp/podmigration-operator/config/samples/migration-example
```
change node seletor in yaml
```
nano 2.yaml 
```
 
run pod
```
kubectl apply -f 2.yaml
```
 
3. Wait until pod is running
 ```
 kubectl get pods
 ```
 
 4. Migrate command
  ```
  kubectl migrate video worker1
  ```

## Typical errors
### go not found
- Often the source of the bash is not set
```
source $HOME/.profile
```
