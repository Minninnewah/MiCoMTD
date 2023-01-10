from enums.scheduler_mode import SchedulerMode
from enums.mtd_action import MTDAction

class Scheduler:
    mode = SchedulerMode.MANUEL
    manuel_action = MTDAction.DO_NOTHING

    def set_mode(self, schedulerMode):
        self.mode = schedulerMode
    
    def get_mode(self):
        return self.mode

    def set_manuel_MTD_action(self, action):
        self.manuel_action = action
    
    def schedule (self):
        if self.mode == SchedulerMode.MANUEL:
            if not self.manuel_action.value.isReady():
                self.manuel_action.value.generate_random_values()
            self.manuel_action.value.execute()
            self.manuel_action = MTDAction.DO_NOTHING
            pass
        elif self.mode == SchedulerMode.AUTO:
            #Choose MDT action
            #Execute MDT action
            pass
        else:
            raise Exception("Mode is not allowed")