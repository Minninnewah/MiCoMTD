from api.topofuzzer_handler import TopoFuzzerHandler
from scheduler import Scheduler
import api.api_server as api
import environment
import time

def main():

    topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
    scheduler = Scheduler()

    #Set up api server
    api.start_API_server(scheduler)
    print("API server started")


    while True:
        print(f"Scheduler Mode: {scheduler.get_mode().name}")
        scheduler.schedule()
        time.sleep(5 - time.time() % 5)
    


    #topoFuzzer_handler.expose_service("213.12.21.2", "192.123.2.1")
    #results = topoFuzzer_handler.get_all_entries()
    #print(results)
    #topoFuzzer_handler.update_service("213.12.21.2", "192.123.2.5")
    #results = topoFuzzer_handler.get_all_entries()
    #print(results)
    

if __name__ == "__main__":
    main()
