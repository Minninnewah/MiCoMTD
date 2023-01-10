from .action_executor import ActionExecutor
import environment
import random
from api.server_controller_handler import getServices, restartService


class ReinstantiationExecutor(ActionExecutor):
    def __init__(self):
        self.service = ""
        pass
    
    def setup(self, service):
        self.service = service

    def isReady(self):
        return not self.service == ""

    def generate_random_values(self): 
        cluster_selector = random.randrange(len(environment.Server_controller_ips))
        data = getServices(environment.Server_controller_ips[cluster_selector], environment.Server_controller_port).json()
        service_selector = random.randrange(len(data))
        self.service = data[service_selector]

    def execute(self):
        print("Reinstantiation Executor")

        if self.service == "":
            print("No service selected")
            return

        # Filter clusters that have this service running
        server_controller_ips = []
        for ip in environment.Server_controller_ips:
            data = getServices(ip, environment.Server_controller_port).json()
            if self.service in data:
                server_controller_ips.append(ip)

        # Restart the service on all cluster
        for ip in server_controller_ips:
            restartService(ip, environment.Server_controller_port, self.service)

        if len(server_controller_ips) == 0:
            print("Service cannot be found")
        
        self.service = ""

