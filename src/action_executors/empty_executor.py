from .action_executor import ActionExecutor

class EmptyExecutor(ActionExecutor):
    def __init__(self):
        pass
    
    def execute(self):
        print("Empty executor")
        pass
