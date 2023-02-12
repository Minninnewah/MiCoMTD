from .action_executor import ActionExecutor

class EmptyExecutor(ActionExecutor):
    def __init__(self):
        pass
    
    def execute(self):
        print("Empty executor")
        pass

    def isReady(self): 
        return True

    def generate_random_values(self):
        pass