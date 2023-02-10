from .action_executor import ActionExecutor
from api.server_controller_handler import startService, stopService, getServiceState
import environment
from api.topofuzzer_handler import TopoFuzzerHandler
import time

class MigrationExecutor(ActionExecutor):
    def __init__(self):
        self.topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
        self.service = ""
        self.origin = list(environment.clusters.keys())[0]
        self.destination = list(environment.clusters.keys())[1]

    def setup(self, service = "", origin = "", dest = ""):
        self.service = service
        self.origin = origin
        self.destination = dest
    
    def execute(self):
        print("Migration Executor")

        # How to handle yaml files? On each master predowloaded? stored in MTC controller, server controller?
        # How to handle depends on services?

        service_To_Migrate = "simple-stateless"

        stateless = True

        if(stateless):
            # start service at new location
            print("[" + time.ctime() + "] Start service " + self.service + " on cluster " + self.destination)
            startService(environment.clusters[self.destination], environment.Server_controller_port, environment.service_manifests[self.service])

            while not getServiceState(environment.clusters[self.destination], environment.Server_controller_port, self.service):
                time.sleep(100/1000)
                print(".", end = '', flush=True)

            print("")
            print("[" + time.ctime() + "] Service started successfully")
            #change ip on topoFuzzer
            print("Switch traffic from cluster " + self.origin + "(" + environment.clusters[self.origin] + ") to cluster " + self.destination + "(" + environment.clusters[self.destination] + ")" )


            self.topoFuzzer_handler.update_public_mapping(environment.service_subnet_mapping[self.service], environment.local_ip[self.destination])
            #self.topoFuzzer_handler.update_service() #ToDo
            #results = topoFuzzer_handler.get_all_entries()
            # stop old service
            #time.sleep(10)
            stopService(environment.clusters[self.origin], environment.Server_controller_port, environment.service_manifests[self.service])
        else:
            print("Only stateless migration is supported.")
            

    def isReady(self): 
        return not self.service == None and self.service == ""

    def generate_random_values(self):
        pass