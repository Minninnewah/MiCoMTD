import requests
import time
import pandas as pd
from api.server_controller_handler import getNodeMetrics, getPodMetrics
import environment

if __name__ == "__main__":
    latency = {}
    node_metrics = {}
    pod_metrics = {}
    counter = 10
    test = pd.Series()

    while True:
        
        timestamp = time.ctime()
        #response = requests.get('http://10.161.7.123:30004')
        response = requests.get('http://google.com')
        
        if response.status_code == 200:
            latency[timestamp] = response.elapsed.total_seconds()
        else:
            latency[timestamp] = None

        if counter >= 5:
            for cluster in environment.clusters:
                node_data = getNodeMetrics(environment.clusters[cluster], environment.Server_controller_port)
                pod_data = getPodMetrics(environment.clusters[cluster], environment.Server_controller_port)

                # Fill node data into pd.Series
                for data in node_data:
                    if data["name"] + "_cpu" in node_metrics:
                        node_metrics[data["name"] + "_cpu"] = pd.concat([node_metrics[data["name"] + "_cpu"], pd.Series({timestamp: data["cpu"]}, name=data["name"] + "_cpu")])
                        node_metrics[data["name"] + "_memory"] = pd.concat([node_metrics[data["name"] + "_memory"], pd.Series({timestamp: data["memory"]}, name= data["name"] + "_memory")])
                    else:
                        node_metrics[data["name"] + "_cpu"] = pd.Series({timestamp: data["cpu"]}, name=data["name"] + "_cpu")
                        node_metrics[data["name"] + "_memory"] = pd.Series({timestamp: data["memory"]}, name= data["name"] + "_memory")

                # Fill pod data into pd.Series
                for data in pod_data:
                    if data["name"] + "_cpu" in pod_metrics:
                        pod_metrics[data["name"] + "_cpu"] = pd.concat([pod_metrics[data["name"] + "_cpu"], pd.Series({timestamp: data["cpu"]}, name=data["name"] + "_cpu")])
                        pod_metrics[data["name"] + "_memory"] = pd.concat([pod_metrics[data["name"] + "_memory"], pd.Series({timestamp: data["memory"]}, name=data["name"] + "_memory")])
                    else:
                        pod_metrics[data["name"] + "_cpu"] = pd.Series({timestamp: data["cpu"]}, name=data["name"] + "_cpu")
                        pod_metrics[data["name"] + "_memory"] = pd.Series({timestamp: data["memory"]}, name=data["name"] + "_memory")
            counter = 0
        
        time.sleep(1 - time.time() % 1)
        


        counter += 1
        print(node_metrics["master_cpu"].head(3))
        combined_metrics = pd.DataFrame(pd.Series(latency, name="Latency"))
        for metrics in node_metrics:
            combined_metrics = pd.concat([combined_metrics, node_metrics[metrics]], axis=1)

        for metrics in pod_metrics:
            combined_metrics = pd.concat([combined_metrics, pod_metrics[metrics]], axis=1)
        
        combined_metrics.to_csv("test.csv")
        print(combined_metrics.head(3))
        #series = pd.Series(latency, name="Latency")
        #print(pd.DataFrame(series))
