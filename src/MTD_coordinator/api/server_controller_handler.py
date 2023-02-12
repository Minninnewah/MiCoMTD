import requests

def restartService(ip, port, service):
    data = requests.get('http://' + ip + ":" + str(port) + "/restart/" + service)
    return data

def getNodes(ip, port):
    data = requests.get('http://' + ip + ":" + str(port) + "/nodes")
    return data

def getPods(ip, port):
    data = requests.get('http://' + ip + ":" + str(port) + "/pods")
    return data

def getServices(ip, port):
    data = requests.get('http://' + ip + ":" + str(port) + "/services")
    return data

def startService(ip, port, manifest_url):
    data = requests.post('http://' + ip + ":" + str(port) + "/start", json={ "manifest_url": manifest_url })
    return data

def stopService(ip, port, manifest_url):
    data = requests.delete('http://' + ip + ":" + str(port) + "/stop", json={ "manifest_url": manifest_url })
    return data

def getServiceState(ip, port, service):
    data = requests.get('http://' + ip + ":" + str(port) + "/status/" + service).json()
    return data["isRunning"]

def getNodeMetrics(ip, port):
    data = requests.get('http://' + ip + ":" + str(port) + "/metrics/nodes").json()
    return data

def getPodMetrics(ip, port):
    data = requests.get('http://' + ip + ":" + str(port) + "/metrics/pods").json()
    return data

def migrateService(ip, port, service, dest_node):
    data = requests.put('http://' + ip + ":" + str(port) + "/migrate/" + service, json={ "destinationNode": dest_node })
    return data