# MiCoMTD


## Testbed
To set up the testbed for this MTC controller, follow [these steps](https://github.com/Minninnewah/MiCoMTD/tree/main/testbed#readme)

## Server controller
Each cluster in the environment needs a running instance of the server-controller on the master node. This controller is responsible for converting API calls to kubectl commands. The controller can be started using:
```
wget -O - https://raw.githubusercontent.com/Minninnewah/MiCoMTD/main/src/server_controller/index.js | node
```
Requirements:
express: ```npm install express```
wget: ```sudo apt install wget -y``` (for dowloading file)
npm: ```sudo apt install npm -y``` (for installing express pkg)

### API
- /nodes              | Get all the different nodes in this cluster. ```curl localhost:6666/nodes```
- /pods               | Get all the different pods in this cluster and on which node they are places. ```curl localhost:6666/pods```
- /services           | Get all the different services in this cluster and the associated IP. ```curl localhost:6666/services```
- /restart/:service   | Restart a service without downtimes ```curl localhost:6666/restart/cloud-db-handler```

## MTD controller
The MTC controller is responsible for scheduling and controlling of the MTD actions.
