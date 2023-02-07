from .action_executor import ActionExecutor
from api.server_controller_handler import startService, stopService, getServiceState
import environment
from api.topofuzzer_handler import TopoFuzzerHandler
import time

class MigrationExecutor(ActionExecutor):
    def __init__(self):
        self.topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
        self.service = ""
        pass

    def setup(self, service = "", origin = "", dest = ""):
        self.service = service
        self.origin = origin
        self.destination = dest
    
    def execute(self):
        print("Migration Executor")

        # How to handle yaml files? On each master predowloaded? stored in MTC controller, server controller?
        # How to handle depends on services?


        service_To_Migrate = "simple-stateless"
        origin_cluster = "cluster_1"
        dest_cluster = "cluster_2"

        stateless = True

        if(stateless):
            # start service at new location
            print("Start service " + service_To_Migrate + " on cluster " + dest_cluster)
            startService(environment.clusters[dest_cluster], environment.Server_controller_port, environment.service_manifests[service_To_Migrate])

            while not getServiceState(environment.clusters[dest_cluster], environment.Server_controller_port, service_To_Migrate):
                time.sleep(100/1000)
                print(".", end = '')

            print("Service started successfully")
            #change ip on topoFuzzer

            #self.topoFuzzer_handler.update_service() #ToDo
            #results = topoFuzzer_handler.get_all_entries()
            # stop old service
            #stopService(environment.clusters[origin_cluster], environment.Server_controller_port, service_To_Migrate)
            
        pass

    def isReady(self): 
        return not self.service == None and self.service == ""

    def generate_random_values(self):
        pass