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
    data = requests.delete('http://' + ip + ":" + str(port) + "/start", json={ "manifest_url": manifest_url })
    return data

def stopService(ip, port, manifest_url):
    data = requests.delete('http://' + ip + ":" + str(port) + "/stop", json={ "manifest_url": manifest_url })
    return data

def getServiceState(ip, port, service):
    data = requests.get('http://' + ip + ":" + str(port) + "/status/" + service)
    print(data)
    return data.isRunning