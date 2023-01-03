from abc import abstractmethod, ABC

class ActionExecutor(ABC):

    @abstractmethod
    def execute(self): 
        pass

    