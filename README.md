# MiCoMTD (Microservice Container MTD)


## Testbed
To set up the testbed for this MTC coordinator, follow [these steps](https://github.com/Minninnewah/MiCoMTD/tree/main/testbed#readme)

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

## MTD coordinator
The MTC coordinator is responsible for scheduling and controlling of the MTD actions. It will start an API server so send control commands to the MTD coordinator which then use different executors to execute the different MTD actions.

### Run
#### Activate virtual environement

Create venv
```
.python3 -m venv venv
```
Activate venv
```
.\venv\Scripts\activate
```
Install dependencies
```
pip3 install -r .\requirements.txt
```

#### Adapt code
Since the code for the MTD coordinator is configured for our test environment there are a few adaptions that have to be done. To keep it simple all the basic environment based configuration is stored in the file ```environment.py```
- Adapt the ip and port of your TopoFuzzer instance (port is the default port of TopoFuzzer)
- Add all the ip addresses of the instance on which the server_controllers are running (this should be one per cluster and by default the master node)
- Adapt the server_controller port if not kept at default value
- Add all the servic manifest urls (are needed in to start and stop services -> for migration)

#### Run code
```
python ./src/MTD_coodinator/mtd_controller.py
```

### API
| Type | Path    | Body params                                     | Description                         |
|------|---------|-------------------------------------------------|-------------------------------------|
| get  | /mode   |                                                 | Returns the current scheduling mode |
| put  | /mode   | mode                                            | Set the scheduling mode             |
| post | /action | action, service and also (origin]) (destiantion)| Set MTD action                      |
| get  | /action |                                                 | Return all the supported actions    |

When posting a new action the parameter in () depends on the selected action parameter.
