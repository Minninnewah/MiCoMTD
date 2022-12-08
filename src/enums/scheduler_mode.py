from enum import Enum

class SchedulerMode(Enum):
    AUTO = 1
    MANUEL = 2

    def get_list():
        return [el.name for el in SchedulerMode]