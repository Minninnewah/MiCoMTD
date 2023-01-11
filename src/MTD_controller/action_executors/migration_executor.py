from .action_executor import ActionExecutor
from api.server_controller_handler import startService, stopService
import environment
from api.topofuzzer_handler import TopoFuzzerHandler

class MigrationExecutor(ActionExecutor):
    def __init__(self):
        self.topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
        pass

    def setup(self, service = "", origin = "", dest = ""):
        self.service = service
        self.origin = origin
        self.destination = dest
    
    def execute(self):
        print("Migration Executor")

        # How to handle yaml files? On each master predowloaded? stored in MTC controller, server controller?
        # How to handle depends on services?


        service_To_Migrate = "drone"
        origin_cluster = "cluster_1"
        dest_cluster = "cluster_2"

        stateless = True

        if(stateless):
            # start service at new location
            startService(environment.clusters[dest_cluster], environment.Server_controller_port, service_To_Migrate)
            #change ip on topoFuzzer
            self.topoFuzzer_handler.update_service() #ToDo
            #results = topoFuzzer_handler.get_all_entries()
            # stop old service
            stopService(environment.clusters[origin_cluster], environment.Server_controller_port, service_To_Migrate)
            
        pass

    def isReady(self): 
        return self.service == ""

    def generate_random_values(self):
        pass