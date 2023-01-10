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