from abc import abstractmethod, ABC

class ActionExecutor(ABC):

    @abstractmethod
    def execute(self): 
        pass

    @abstractmethod
    def isReady(self): 
        pass

    @abstractmethod
    def generate_random_values(self): 
        pass

    