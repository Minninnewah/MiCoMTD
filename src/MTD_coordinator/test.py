from api.topofuzzer_handler import TopoFuzzerHandler
import environment
import requests
from action_executors.reinstantiation_executor import ReinstantiationExecutor
import time

if __name__ == "__main__":
    #topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
    #results = topoFuzzer_handler.get_all_entries()
    #print(results)
    #topoFuzzer_handler.expose_service("160.85.253.118", "160.85.253.79")
    #results = topoFuzzer_handler.get_all_entries()
    #print(results)
    while True:
        time.sleep(2 - time.time() % 2)
        print("Test")

    #executor = ReinstantiationExecutor()
    #executor.execute()