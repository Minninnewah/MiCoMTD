from .action_executor import ActionExecutor

class MigrationExecutor(ActionExecutor):
    def __init__(self):
        pass
    
    def execute(self):
        print("Migration Executor")
        pass

    def isReady(self): 
        return False

    def generate_random_values(self):
        pass